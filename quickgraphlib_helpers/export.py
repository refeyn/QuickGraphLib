# SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

import math
import pathlib
from typing import Any, Mapping

from PySide6 import QtCore, QtGui, QtQml, QtSvg

from .consts import (  # pylint: disable=unused-import
    QML_IMPORT_MAJOR_VERSION,
    QML_IMPORT_MINOR_VERSION,
    QML_IMPORT_NAME,
)


def _export_child_to_painter(data: Mapping[str, Any], painter: QtGui.QPainter) -> None:
    if "x" in data:  # An Item
        if not data["visible"]:
            return
        painter.save()
        painter.translate(data["x"], data["y"])
        painter.setOpacity(data["opacity"])
        rect = QtCore.QRectF(0, 0, data["width"], data["height"])
        if data["clip"]:
            # Note: doesn't work for SVGs until 6.7
            painter.setClipRect(rect)

        childrenZSorted = sorted(data["children"], key=lambda c: c.get("z", 0))

        for tr in data["transform"][::-1]:
            if tr is None:
                pass
            elif tr["type"] == "translate":
                painter.translate(tr["x"], tr["y"])
            elif tr["type"] == "rotation":
                painter.translate(tr["origin"].x(), tr["origin"].y())
                painter.rotate(tr["angle"])
                painter.translate(-tr["origin"].x(), -tr["origin"].y())
            elif tr["type"] == "scale":
                painter.translate(tr["origin"].x(), tr["origin"].y())
                painter.scale(tr["xScale"], tr["yScale"])
                painter.translate(-tr["origin"].x(), -tr["origin"].y())
            elif tr["type"] == "matrix4x4":
                painter.setTransform(tr["matrix"].toTransform())

        for c in childrenZSorted:
            if c.get("z", 0) < 0:
                _export_child_to_painter(c, painter)

        if data["type"] == "text":
            painter.save()
            font = QtGui.QFont(data["fontFamily"], 1, data["fontWeight"])
            font.setPixelSize(data["fontSize"])
            painter.setFont(font)
            painter.setPen(data["color"])
            painter.drawText(rect, data["text"])
            painter.restore()
        if data["type"] == "rectangle":
            painter.save()
            if data["border_width"] > 0:
                pen = QtGui.QPen(data["border_color"])
                pen.setWidthF(data["border_width"])
            else:
                pen = QtGui.QPen(QtCore.Qt.PenStyle.NoPen)
            painter.setPen(pen)
            painter.setBrush(data["color"])
            painter.drawRoundedRect(rect, data["radius"], data["radius"])
            painter.restore()

        for c in childrenZSorted:
            if c.get("z", 0) >= 0:
                _export_child_to_painter(c, painter)
        painter.restore()

    elif data["type"] == "shape_path":
        painter.save()
        pen = QtGui.QPen(data["strokeColor"])
        pen.setWidth(data["strokeWidth"])
        painter.setPen(pen)
        if data["fillGradient"] is None:
            brush = QtGui.QBrush(data["fillColor"])
        elif data["fillGradient"]["type"] == "lineargradient":
            lingrad = QtGui.QLinearGradient(
                data["fillGradient"]["x1"],
                data["fillGradient"]["y1"],
                data["fillGradient"]["x2"],
                data["fillGradient"]["y2"],
            )
            lingrad.setStops(
                [(s["position"], s["color"]) for s in data["fillGradient"]["stops"]]
            )
            brush = QtGui.QBrush(lingrad)
        painter.setBrush(brush)
        for c in data["elements"]:
            _export_child_to_painter(c, painter)
        painter.restore()

    elif data["type"] == "polyline":
        brush = painter.brush()
        pen = painter.pen()
        painter.setPen(QtCore.Qt.PenStyle.NoPen)
        painter.drawPolygon(data["path"])
        painter.setPen(pen)
        painter.setBrush(QtCore.Qt.BrushStyle.NoBrush)
        painter.drawPolyline(data["path"])
        painter.setBrush(brush)

    elif data["type"] == "multiline":
        brush = painter.brush()
        pen = painter.pen()
        fill_path = QtGui.QPainterPath()
        for path in data["paths"]:
            fill_path.addPolygon(QtGui.QPolygonF(path))
            fill_path.closeSubpath()

        painter.setPen(QtCore.Qt.PenStyle.NoPen)
        painter.drawPath(fill_path)
        painter.setPen(pen)
        painter.setBrush(QtCore.Qt.BrushStyle.NoBrush)
        for path in data["paths"]:
            painter.drawPolyline(path)
        painter.setBrush(brush)


def export_to_painter(data: Mapping[str, Any], painter: QtGui.QPainter) -> None:
    painter.setRenderHint(QtGui.QPainter.RenderHint.Antialiasing, True)
    painter.setRenderHint(QtGui.QPainter.RenderHint.TextAntialiasing, True)
    _export_child_to_painter(data, painter)


def export_to_paintdevice(data: Mapping[str, Any], device: QtGui.QPaintDevice) -> None:
    painter = QtGui.QPainter()
    painter.begin(device)
    try:
        export_to_painter(data, painter)
    finally:
        painter.end()


def export_to_svg(data: Mapping[str, Any], path: pathlib.Path) -> None:
    device = QtSvg.QSvgGenerator()
    device.setFileName(str(path))
    export_to_paintdevice(data, device)


def export_to_png(data: Mapping[str, Any], path: pathlib.Path, dpi: int = 96) -> None:
    device = QtGui.QPixmap(
        math.ceil((data["width"] + data["x"]) * dpi / 96),
        math.ceil((data["height"] + data["y"]) * dpi / 96),
    )
    device.fill(QtCore.Qt.GlobalColor.transparent)
    device.setDevicePixelRatio(dpi / 96)
    export_to_paintdevice(data, device)
    device.save(str(path))


@QtQml.QmlElement
@QtQml.QmlSingleton
class ExportHelper(QtCore.QObject):
    @QtCore.Slot(dict, QtCore.QUrl)
    def exportToSvg(self, data: Mapping[str, Any], path: QtCore.QUrl) -> None:
        export_to_svg(data, pathlib.Path(path.toLocalFile()))

    @QtCore.Slot(dict, QtCore.QUrl)
    def exportToPng(self, data: Mapping[str, Any], path: QtCore.QUrl) -> None:
        export_to_png(data, pathlib.Path(path.toLocalFile()))
