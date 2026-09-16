// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    property bool completedSuccessfully: false
    property string failureMessage: ""

    function assertRect(actual, expected, message) {
        if (actual.x !== expected.x || actual.y !== expected.y || actual.width !== expected.width || actual.height !== expected.height) {
            throw new Error(message + ": expected " + expected + ", got " + actual);
        }
    }

    height: 600
    viewRect: Qt.rect(0, 0, 10, 10)
    width: 800

    Component.onCompleted: {
        try {
            assertRect(rectangleRoi._resizedFromHandle(rectangleRoi.topLeftHandle, Qt.point(1, 1)), Qt.rect(1, 1, 7, 5), "rectangle top-left resize mismatch");
            assertRect(rectangleRoi._resizedFromHandle(rectangleRoi.topRightHandle, Qt.point(9, 1)), Qt.rect(2, 1, 7, 5), "rectangle top-right resize mismatch");
            assertRect(rectangleRoi._resizedFromHandle(rectangleRoi.bottomLeftHandle, Qt.point(1, 7)), Qt.rect(1, 2, 7, 5), "rectangle bottom-left resize mismatch");
            assertRect(rectangleRoi._resizedFromHandle(rectangleRoi.bottomRightHandle, Qt.point(9, 7)), Qt.rect(2, 2, 7, 5), "rectangle bottom-right resize mismatch");
            assertRect(rectangleRoi._resizedFromHandle(rectangleRoi.topLeftHandle, Qt.point(10, 10)), Qt.rect(8, 6, 0, 0), "rectangle top-left resize crossed bottom-right anchor");
            assertRect(rectangleRoi._resizedFromHandle(rectangleRoi.topRightHandle, Qt.point(0, 10)), Qt.rect(2, 6, 0, 0), "rectangle top-right resize crossed bottom-left anchor");
            assertRect(rectangleRoi._resizedFromHandle(rectangleRoi.bottomLeftHandle, Qt.point(10, 0)), Qt.rect(8, 2, 0, 0), "rectangle bottom-left resize crossed top-right anchor");
            assertRect(rectangleRoi._resizedFromHandle(rectangleRoi.bottomRightHandle, Qt.point(0, 0)), Qt.rect(2, 2, 0, 0), "rectangle bottom-right resize crossed top-left anchor");
            assertRect(ellipseRoi._resizedFromHandle(ellipseRoi.leftHandle, Qt.point(10, 4)), Qt.rect(8, 2, 0, 4), "ellipse left resize crossed right edge");
            assertRect(ellipseRoi._resizedFromHandle(ellipseRoi.bottomHandle, Qt.point(5, 0)), Qt.rect(2, 2, 6, 0), "ellipse bottom resize crossed top edge");

            rectangleRoi.minimumDataWidth = 0.5;
            rectangleRoi.minimumDataHeight = 0.25;
            ellipseRoi.minimumDataWidth = 0.5;
            ellipseRoi.minimumDataHeight = 0.25;

            assertRect(rectangleRoi._resizedFromHandle(rectangleRoi.topLeftHandle, Qt.point(10, 10)), Qt.rect(7.5, 5.75, 0.5, 0.25), "rectangle resize did not preserve minimum size");
            assertRect(rectangleRoi._resizedFromHandle(rectangleRoi.topRightHandle, Qt.point(0, 10)), Qt.rect(2, 5.75, 0.5, 0.25), "rectangle top-right resize did not preserve minimum size");
            assertRect(rectangleRoi._resizedFromHandle(rectangleRoi.bottomLeftHandle, Qt.point(10, 0)), Qt.rect(7.5, 2, 0.5, 0.25), "rectangle bottom-left resize did not preserve minimum size");
            assertRect(rectangleRoi._resizedFromHandle(rectangleRoi.bottomRightHandle, Qt.point(0, 0)), Qt.rect(2, 2, 0.5, 0.25), "rectangle bottom-right resize did not preserve minimum size");
            assertRect(ellipseRoi._resizedFromHandle(ellipseRoi.rightHandle, Qt.point(0, 4)), Qt.rect(2, 2, 0.5, 4), "ellipse resize did not preserve minimum width");

            rectangleRoi.minimumDataWidth = -1;
            rectangleRoi.minimumDataHeight = -1;
            assertRect(rectangleRoi._resizedFromHandle(rectangleRoi.topLeftHandle, Qt.point(10, 10)), Qt.rect(8, 6, 0, 0), "rectangle negative minimum size was not clamped to zero");
            completedSuccessfully = true;
        } catch (error) {
            failureMessage = error.toString();
        }
    }

    QGLGraphItems.RectangleHandles {
        id: rectangleRoi

        dataRect: Qt.rect(2, 2, 6, 4)
        dataTransform: axes.dataTransform
        selected: true
    }
    QGLGraphItems.EllipseHandles {
        id: ellipseRoi

        dataRect: Qt.rect(2, 2, 6, 4)
        dataTransform: axes.dataTransform
        selected: true
    }
}
