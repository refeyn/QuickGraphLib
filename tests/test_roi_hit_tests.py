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
    QGLGraphItems.RectangleRoi {
        id: rectangleRoi

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

        if (!rectangleRoi.containsBodyScenePoint(axes.dataTransform.map(Qt.point(5, 4)))) {
            throw new Error("rectangle inside point missed");
        }
        if (rectangleRoi.containsBodyScenePoint(axes.dataTransform.map(Qt.point(1, 4)))) {
            throw new Error("rectangle outside point hit");
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


def test_axis_aligned_roi_resize_handles_clamp_at_opposite_anchor() -> None:
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

    QGLGraphItems.RectangleRoi {
        id: rectangleRoi

        dataTransform: axes.dataTransform
        dataRect: Qt.rect(2, 2, 6, 4)
        selected: true
    }
    QGLGraphItems.EllipseRoi {
        id: ellipseRoi

        dataTransform: axes.dataTransform
        dataRect: Qt.rect(2, 2, 6, 4)
        selected: true
    }

    function assertRect(actual, expected, message) {
        if (actual.x !== expected.x || actual.y !== expected.y
                || actual.width !== expected.width || actual.height !== expected.height) {
            throw new Error(message + ": expected " + expected + ", got " + actual);
        }
    }

    Component.onCompleted: {
        assertRect(
            rectangleRoi.resizedFromHandle(rectangleRoi.topLeftHandle, Qt.point(10, 10)),
            Qt.rect(8, 6, 0, 0),
            "rectangle top-left resize crossed bottom-right anchor"
        );
        assertRect(
            rectangleRoi.resizedFromHandle(rectangleRoi.bottomRightHandle, Qt.point(0, 0)),
            Qt.rect(2, 2, 0, 0),
            "rectangle bottom-right resize crossed top-left anchor"
        );
        assertRect(
            ellipseRoi.resizedFromHandle(ellipseRoi.leftHandle, Qt.point(10, 4)),
            Qt.rect(8, 2, 0, 4),
            "ellipse left resize crossed right edge"
        );
        assertRect(
            ellipseRoi.resizedFromHandle(ellipseRoi.bottomHandle, Qt.point(5, 0)),
            Qt.rect(2, 2, 6, 0),
            "ellipse bottom resize crossed top edge"
        );

        rectangleRoi.minimumDataWidth = 0.5;
        rectangleRoi.minimumDataHeight = 0.25;
        ellipseRoi.minimumDataWidth = 0.5;
        ellipseRoi.minimumDataHeight = 0.25;

        assertRect(
            rectangleRoi.resizedFromHandle(rectangleRoi.topLeftHandle, Qt.point(10, 10)),
            Qt.rect(7.5, 5.75, 0.5, 0.25),
            "rectangle resize did not preserve minimum size"
        );
        assertRect(
            ellipseRoi.resizedFromHandle(ellipseRoi.rightHandle, Qt.point(0, 4)),
            Qt.rect(2, 2, 0.5, 4),
            "ellipse resize did not preserve minimum width"
        );
    }
}
""",
        QtCore.QUrl(),
    )
    item = component.create()
    assert item is not None, [error.toString() for error in component.errors()]
    item.deleteLater()
    app.processEvents()


def test_roi_handles_expose_role_specific_cursors() -> None:
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
    QGLGraphItems.RectangleRoi {
        id: rectangleRoi

        dataTransform: axes.dataTransform
        dataRect: Qt.rect(2, 2, 6, 4)
        handleMode: QGLGraphItems.RectangleRoi.CornersAndCenter
        selected: true
    }
    QGLGraphItems.EllipseRoi {
        id: ellipseRoi

        dataTransform: axes.dataTransform
        dataRect: Qt.rect(2, 2, 6, 4)
        handleMode: QGLGraphItems.EllipseRoi.CardinalAndCenter
        selected: true
    }

    Component.onCompleted: {
        if (rectangleRoi.topLeftHandle.cursorShape !== Qt.SizeBDiagCursor
                || rectangleRoi.bottomRightHandle.cursorShape !== Qt.SizeBDiagCursor) {
            throw new Error("rectangle backward diagonal cursor mismatch");
        }
        if (rectangleRoi.topRightHandle.cursorShape !== Qt.SizeFDiagCursor
                || rectangleRoi.bottomLeftHandle.cursorShape !== Qt.SizeFDiagCursor) {
            throw new Error("rectangle forward diagonal cursor mismatch");
        }
        if (rectangleRoi.centerHandle.cursorShape !== Qt.SizeAllCursor) {
            throw new Error("rectangle move cursor mismatch");
        }
        if (ellipseRoi.leftHandle.cursorShape !== Qt.SizeHorCursor
                || ellipseRoi.rightHandle.cursorShape !== Qt.SizeHorCursor) {
            throw new Error("ellipse horizontal resize cursor mismatch");
        }
        if (ellipseRoi.topHandle.cursorShape !== Qt.SizeVerCursor
                || ellipseRoi.bottomHandle.cursorShape !== Qt.SizeVerCursor) {
            throw new Error("ellipse vertical resize cursor mismatch");
        }
        if (ellipseRoi.centerHandle.cursorShape !== Qt.SizeAllCursor) {
            throw new Error("ellipse move cursor mismatch");
        }
        if (lineRoi.point1Handle.cursorShape !== Qt.PointingHandCursor
                || lineRoi.point2Handle.cursorShape !== Qt.PointingHandCursor) {
            throw new Error("line endpoint cursor mismatch");
        }
        if (polylineRoi.handles[0].cursorShape !== Qt.PointingHandCursor) {
            throw new Error("polyline vertex cursor mismatch");
        }
        if (polygonRoi.handles[0].cursorShape !== Qt.PointingHandCursor) {
            throw new Error("polygon vertex cursor mismatch");
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
