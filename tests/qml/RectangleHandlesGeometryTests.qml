// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib.GraphItems as QGLGraphItems

Item {
    id: root

    property bool completedSuccessfully: false
    property string failureMessage: ""
    readonly property matrix4x4 identityTransform: Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
    readonly property matrix4x4 invertedAxisTransform: Qt.matrix4x4(-2, 0, 0, 10, 0, -3, 0, 100, 0, 0, 1, 0, 0, 0, 0, 1)
    readonly property matrix4x4 rotationTransform: Qt.matrix4x4(0.8660254, -0.5, 0, 0, 0.5, 0.8660254, 0, 0, 0, 1, 0, 0, 0, 0, 1)
    readonly property matrix4x4 shearTransform: Qt.matrix4x4(1, 0.5, 0, 0, 0.25, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1)

    function assertClose(actual, expected, message) {
        if (Math.abs(actual - expected) > 0.001) {
            throw new Error(message + ": expected " + expected + ", got " + actual);
        }
    }
    function assertPointClose(actual, expected, message) {
        assertClose(actual.x, expected.x, message + " x");
        assertClose(actual.y, expected.y, message + " y");
    }
    function assertRectangleGeometry(handles, message) {
        let left = Math.min(handles.dataRect.x, handles.dataRect.x + handles.dataRect.width);
        let right = Math.max(handles.dataRect.x, handles.dataRect.x + handles.dataRect.width);
        let top = Math.min(handles.dataRect.y, handles.dataRect.y + handles.dataRect.height);
        let bottom = Math.max(handles.dataRect.y, handles.dataRect.y + handles.dataRect.height);
        let normalizedRect = Qt.rect(left, top, right - left, bottom - top);
        let bottomLeft = Qt.point(left, bottom);
        let bottomRight = Qt.point(right, bottom);
        let center = Qt.point((left + right) / 2, (top + bottom) / 2);
        let topLeft = Qt.point(left, top);
        let topRight = Qt.point(right, top);
        let mappedBottomLeft = handles.dataTransform.map(bottomLeft);
        let mappedBottomRight = handles.dataTransform.map(bottomRight);
        let mappedTopLeft = handles.dataTransform.map(topLeft);
        let mappedTopRight = handles.dataTransform.map(topRight);
        let mappedRect = handles.dataTransform.mapRect(normalizedRect);

        assertClose(handles._dataLeft, left, message + " data left");
        assertClose(handles._dataRight, right, message + " data right");
        assertClose(handles._dataTop, top, message + " data top");
        assertClose(handles._dataBottom, bottom, message + " data bottom");
        assertPointClose(handles._bottomLeftPoint, bottomLeft, message + " bottom-left point");
        assertPointClose(handles._bottomRightPoint, bottomRight, message + " bottom-right point");
        assertPointClose(handles._centerPoint, center, message + " center point");
        assertPointClose(handles._topLeftPoint, topLeft, message + " top-left point");
        assertPointClose(handles._topRightPoint, topRight, message + " top-right point");
        assertPointClose(handles._mappedBottomLeft, mappedBottomLeft, message + " mapped bottom-left");
        assertPointClose(handles._mappedBottomRight, mappedBottomRight, message + " mapped bottom-right");
        assertPointClose(handles._mappedTopLeft, mappedTopLeft, message + " mapped top-left");
        assertPointClose(handles._mappedTopRight, mappedTopRight, message + " mapped top-right");
        assertPointClose(handles._bodyScenePoint(Qt.point(0, 0)), Qt.point(mappedRect.left, mappedRect.top), message + " body origin");
        assertPointClose(handles.bottomLeftHandle.position, bottomLeft, message + " bottom-left handle data position");
        assertPointClose(handles.bottomRightHandle.position, bottomRight, message + " bottom-right handle data position");
        assertPointClose(handles.centerHandle.position, center, message + " center handle data position");
        assertPointClose(handles.topLeftHandle.position, topLeft, message + " top-left handle data position");
        assertPointClose(handles.topRightHandle.position, topRight, message + " top-right handle data position");
        assertPointClose(handles.bottomLeftHandle._mappedPosition, mappedBottomLeft, message + " bottom-left handle mapped position");
        assertPointClose(handles.bottomRightHandle._mappedPosition, mappedBottomRight, message + " bottom-right handle mapped position");
        assertPointClose(handles.topLeftHandle._mappedPosition, mappedTopLeft, message + " top-left handle mapped position");
        assertPointClose(handles.topRightHandle._mappedPosition, mappedTopRight, message + " top-right handle mapped position");
    }

    height: 600
    width: 800

    Component.onCompleted: {
        try {
            assertRectangleGeometry(normalRectangle, "normal rectangle");
            assertRectangleGeometry(reversedRectangle, "reversed rectangle");
            assertRectangleGeometry(invertedAxesRectangle, "inverted axes rectangle");
            assertRectangleGeometry(zeroWidthRectangle, "zero-width rectangle");
            assertRectangleGeometry(zeroHeightRectangle, "zero-height rectangle");
            assertRectangleGeometry(rotatedRectangle, "rotated rectangle");
            assertRectangleGeometry(shearedRectangle, "sheared rectangle");
            completedSuccessfully = true;
        } catch (error) {
            failureMessage = error.toString();
        }
    }

    QGLGraphItems.RectangleHandles {
        id: normalRectangle

        dataRect: Qt.rect(2, 3, 6, 4)
        dataTransform: root.identityTransform
        handleMode: QGLGraphItems.RectangleHandles.CornersAndCenter
    }
    QGLGraphItems.RectangleHandles {
        id: reversedRectangle

        dataRect: Qt.rect(8, 7, -6, -4)
        dataTransform: root.identityTransform
        handleMode: QGLGraphItems.RectangleHandles.CornersAndCenter
    }
    QGLGraphItems.RectangleHandles {
        id: invertedAxesRectangle

        dataRect: Qt.rect(2, 3, 6, 4)
        dataTransform: root.invertedAxisTransform
        handleMode: QGLGraphItems.RectangleHandles.CornersAndCenter
    }
    QGLGraphItems.RectangleHandles {
        id: zeroWidthRectangle

        dataRect: Qt.rect(2, 3, 0, 4)
        dataTransform: root.invertedAxisTransform
        handleMode: QGLGraphItems.RectangleHandles.CornersAndCenter
    }
    QGLGraphItems.RectangleHandles {
        id: zeroHeightRectangle

        dataRect: Qt.rect(2, 3, 6, 0)
        dataTransform: root.invertedAxisTransform
        handleMode: QGLGraphItems.RectangleHandles.CornersAndCenter
    }
    QGLGraphItems.RectangleHandles {
        id: rotatedRectangle

        dataRect: Qt.rect(2, 3, 6, 4)
        dataTransform: root.rotationTransform
        handleMode: QGLGraphItems.RectangleHandles.CornersAndCenter
    }
    QGLGraphItems.RectangleHandles {
        id: shearedRectangle

        dataRect: Qt.rect(2, 3, 6, 4)
        dataTransform: root.shearTransform
        handleMode: QGLGraphItems.RectangleHandles.CornersAndCenter
    }
}
