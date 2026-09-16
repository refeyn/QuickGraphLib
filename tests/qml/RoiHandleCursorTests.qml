// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    property bool completedSuccessfully: false
    property string failureMessage: ""

    function assertHandleObjectName(handle, expected) {
        if (handle.objectName !== expected) {
            throw new Error("handle name mismatch: expected " + expected + ", got " + handle.objectName);
        }
    }

    height: 600
    viewRect: Qt.rect(0, 0, 10, 10)
    width: 800

    Component.onCompleted: {
        try {
            if (rectangleRoi.topLeftHandle.cursorShape !== Qt.SizeBDiagCursor || rectangleRoi.bottomRightHandle.cursorShape !== Qt.SizeBDiagCursor) {
                throw new Error("rectangle backward diagonal cursor mismatch");
            }
            if (rectangleRoi.topRightHandle.cursorShape !== Qt.SizeFDiagCursor || rectangleRoi.bottomLeftHandle.cursorShape !== Qt.SizeFDiagCursor) {
                throw new Error("rectangle forward diagonal cursor mismatch");
            }
            if (rectangleRoi.centerHandle.cursorShape !== Qt.SizeAllCursor) {
                throw new Error("rectangle move cursor mismatch");
            }
            if (ellipseRoi.leftHandle.cursorShape !== Qt.SizeHorCursor || ellipseRoi.rightHandle.cursorShape !== Qt.SizeHorCursor) {
                throw new Error("ellipse horizontal resize cursor mismatch");
            }
            if (ellipseRoi.topHandle.cursorShape !== Qt.SizeVerCursor || ellipseRoi.bottomHandle.cursorShape !== Qt.SizeVerCursor) {
                throw new Error("ellipse vertical resize cursor mismatch");
            }
            if (ellipseRoi.centerHandle.cursorShape !== Qt.SizeAllCursor) {
                throw new Error("ellipse move cursor mismatch");
            }
            if (lineRoi.point1Handle.cursorShape !== Qt.PointingHandCursor || lineRoi.point2Handle.cursorShape !== Qt.PointingHandCursor) {
                throw new Error("line endpoint cursor mismatch");
            }
            if (polylineRoi.handles[0].cursorShape !== Qt.PointingHandCursor) {
                throw new Error("polyline vertex cursor mismatch");
            }
            if (polygonRoi.handles[0].cursorShape !== Qt.PointingHandCursor) {
                throw new Error("polygon vertex cursor mismatch");
            }
            assertHandleObjectName(rectangleRoi.topLeftHandle, "topLeft");
            assertHandleObjectName(rectangleRoi.topRightHandle, "topRight");
            assertHandleObjectName(rectangleRoi.bottomLeftHandle, "bottomLeft");
            assertHandleObjectName(rectangleRoi.bottomRightHandle, "bottomRight");
            assertHandleObjectName(rectangleRoi.centerHandle, "center");
            assertHandleObjectName(ellipseRoi.leftHandle, "left");
            assertHandleObjectName(ellipseRoi.rightHandle, "right");
            assertHandleObjectName(ellipseRoi.topHandle, "top");
            assertHandleObjectName(ellipseRoi.bottomHandle, "bottom");
            assertHandleObjectName(ellipseRoi.centerHandle, "center");
            assertHandleObjectName(lineRoi.point1Handle, "point1");
            assertHandleObjectName(lineRoi.point2Handle, "point2");
            assertHandleObjectName(lineRoi.centerHandle, "center");
            for (let index = 0; index < polylineRoi.handles.length; ++index) {
                assertHandleObjectName(polylineRoi.handles[index], "point" + index);
            }
            for (let index = 0; index < polygonRoi.handles.length; ++index) {
                assertHandleObjectName(polygonRoi.handles[index], "point" + index);
            }
            completedSuccessfully = true;
        } catch (error) {
            failureMessage = error.toString();
        }
    }

    QGLGraphItems.LineSegmentHandles {
        id: lineRoi

        dataTransform: axes.dataTransform
        point1: Qt.point(1, 1)
        point2: Qt.point(9, 9)
        selected: true
    }
    QGLGraphItems.PolylineHandles {
        id: polylineRoi

        dataTransform: axes.dataTransform
        points: [Qt.point(1, 1), Qt.point(5, 5), Qt.point(9, 1)]
        selected: true
    }
    QGLGraphItems.PolygonHandles {
        id: polygonRoi

        dataTransform: axes.dataTransform
        points: [Qt.point(1, 1), Qt.point(5, 5), Qt.point(9, 1)]
        selected: true
    }
    QGLGraphItems.RectangleHandles {
        id: rectangleRoi

        dataRect: Qt.rect(2, 2, 6, 4)
        dataTransform: axes.dataTransform
        handleMode: QGLGraphItems.RectangleHandles.CornersAndCenter
        selected: true
    }
    QGLGraphItems.EllipseHandles {
        id: ellipseRoi

        dataRect: Qt.rect(2, 2, 6, 4)
        dataTransform: axes.dataTransform
        handleMode: QGLGraphItems.EllipseHandles.CardinalAndCenter
        selected: true
    }
}
