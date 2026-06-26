# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

from PySide6 import QtCore, QtGui, QtQml, QtQuick

import QuickGraphLib


def test_non_rectangular_roi_body_hit_tests() -> None:
    QtQuick.QQuickWindow.setGraphicsApi(
        QtQuick.QSGRendererInterface.GraphicsApi.Software
    )
    app = QtGui.QGuiApplication.instance() or QtGui.QGuiApplication(
        ["", "-platform", "offscreen"]
    )
    engine = QtQml.QQmlEngine()
    engine.addImportPath(QuickGraphLib.QML_IMPORT_PATH)

    component = QtQml.QQmlComponent(engine)
    component.setData(
        rb"""
import QtQuick
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    width: 800
    height: 600
    viewRect: Qt.rect(0, 0, 10, 10)

    QGLGraphItems.LineSegmentRoi {
        id: lineRoi

        dataTransform: axes.dataTransform
        point1: Qt.point(1, 1)
        point2: Qt.point(9, 9)
        selected: true
    }
    QGLGraphItems.PolylineRoi {
        id: polylineRoi

        dataTransform: axes.dataTransform
        points: [Qt.point(1, 1), Qt.point(5, 5), Qt.point(9, 1)]
        selected: true
    }
    QGLGraphItems.PolygonRoi {
        id: polygonRoi

        dataTransform: axes.dataTransform
        points: [Qt.point(1, 1), Qt.point(5, 5), Qt.point(9, 1)]
        selected: true
    }
    QGLGraphItems.EllipseRoi {
        id: ellipseRoi

        dataTransform: axes.dataTransform
        dataRect: Qt.rect(2, 2, 6, 4)
        selected: true
    }

    Component.onCompleted: {
        if (!lineRoi.containsBodyScenePoint(axes.dataTransform.map(Qt.point(5, 5)))) {
            throw new Error("line inside point missed");
        }
        if (lineRoi.containsBodyScenePoint(axes.dataTransform.map(Qt.point(2, 8)))) {
            throw new Error("line bounding-box point outside segment hit");
        }

        if (!polylineRoi.containsBodyScenePoint(axes.dataTransform.map(Qt.point(5, 5)))) {
            throw new Error("polyline inside point missed");
        }
        if (polylineRoi.containsBodyScenePoint(axes.dataTransform.map(Qt.point(5, 2)))) {
            throw new Error("polyline bounding-box point outside segments hit");
        }

        if (!polygonRoi.containsBodyScenePoint(axes.dataTransform.map(Qt.point(5, 3)))) {
            throw new Error("polygon inside point missed");
        }
        if (polygonRoi.containsBodyScenePoint(axes.dataTransform.map(Qt.point(5, 0.5)))) {
            throw new Error("polygon bounding-box point outside polygon hit");
        }

        if (!ellipseRoi.containsBodyScenePoint(axes.dataTransform.map(Qt.point(5, 4)))) {
            throw new Error("ellipse inside point missed");
        }
        if (ellipseRoi.containsBodyScenePoint(axes.dataTransform.map(Qt.point(2.2, 2.2)))) {
            throw new Error("ellipse bounding-box corner outside ellipse hit");
        }
    }
}
""",
        QtCore.QUrl(),
    )
    item = component.create()
    assert item is not None, [error.toString() for error in component.errors()]
    item.deleteLater()
    app.processEvents()
