// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS
import QuickGraphLib.GraphItems as QGLGraphItems

Item {
    id: root

    property bool completedSuccessfully: false
    property string failureMessage: ""
    readonly property matrix4x4 identityTransform: Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
    readonly property matrix4x4 invertedAxisTransform: Qt.matrix4x4(-2, 0, 0, 10, 0, -3, 0, 100, 0, 0, 1, 0, 0, 0, 0, 1)
    readonly property matrix4x4 rotationTransform: Qt.matrix4x4(0.8660254, -0.5, 0, 0, 0.5, 0.8660254, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
    readonly property matrix4x4 shearTransform: Qt.matrix4x4(1, 0.5, 0, 0, 0.25, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)

    function assertClose(actual, expected, message) {
        if (Math.abs(actual - expected) > 0.001) {
            throw new Error(message + ": expected " + expected + ", got " + actual);
        }
    }
    function assertEllipseGeometry(ellipse, message) {
        let left = Math.min(ellipse.dataRect.x, ellipse.dataRect.x + ellipse.dataRect.width);
        let right = Math.max(ellipse.dataRect.x, ellipse.dataRect.x + ellipse.dataRect.width);
        let top = Math.min(ellipse.dataRect.y, ellipse.dataRect.y + ellipse.dataRect.height);
        let bottom = Math.max(ellipse.dataRect.y, ellipse.dataRect.y + ellipse.dataRect.height);
        let center = Qt.point((left + right) / 2, (top + bottom) / 2);
        let rightCenter = Qt.point(right, center.y);
        let topCenter = Qt.point(center.x, top);
        let mappedRect = ellipse.dataTransform.mapRect(Qt.rect(left, top, right - left, bottom - top));

        assertClose(ellipse._dataLeft, left, message + " dataLeft");
        assertClose(ellipse._dataRight, right, message + " dataRight");
        assertClose(ellipse._dataTop, top, message + " dataTop");
        assertClose(ellipse._dataBottom, bottom, message + " dataBottom");
        assertPointClose(ellipse._dataCenter, center, message + " dataCenter");
        assertPointClose(ellipse._dataRightCenter, rightCenter, message + " dataRightCenter");
        assertPointClose(ellipse._dataTopCenter, topCenter, message + " dataTopCenter");
        assertPointClose(ellipse._mappedCenter, ellipse.dataTransform.map(center), message + " mappedCenter");
        assertPointClose(ellipse._mappedRightCenter, ellipse.dataTransform.map(rightCenter), message + " mappedRightCenter");
        assertPointClose(ellipse._mappedTopCenter, ellipse.dataTransform.map(topCenter), message + " mappedTopCenter");
        assertClose(ellipse._radiusX, mappedRect.width / 2, message + " radiusX");
        assertClose(ellipse._radiusY, mappedRect.height / 2, message + " radiusY");
    }
    function assertPointClose(actual, expected, message) {
        assertClose(actual.x, expected.x, message + " x");
        assertClose(actual.y, expected.y, message + " y");
    }

    Component.onCompleted: {
        try {
            assertEllipseGeometry(normalEllipse, "normal ellipse");
            assertEllipseGeometry(reversedEllipse, "reversed ellipse");
            assertEllipseGeometry(invertedAxesEllipse, "inverted axes ellipse");
            assertEllipseGeometry(zeroWidthEllipse, "zero-width ellipse");
            assertEllipseGeometry(zeroHeightEllipse, "zero-height ellipse");
            assertEllipseGeometry(rotatedEllipse, "rotated ellipse characterization");
            assertEllipseGeometry(shearedEllipse, "sheared ellipse characterization");
            completedSuccessfully = true;
        } catch (error) {
            failureMessage = error.toString();
        }
    }

    QQS.Shape {
        QGLGraphItems.Ellipse {
            id: normalEllipse

            dataRect: Qt.rect(2, 3, 6, 4)
            dataTransform: root.identityTransform
        }
        QGLGraphItems.Ellipse {
            id: reversedEllipse

            dataRect: Qt.rect(8, 7, -6, -4)
            dataTransform: root.identityTransform
        }
        QGLGraphItems.Ellipse {
            id: invertedAxesEllipse

            dataRect: Qt.rect(2, 3, 6, 4)
            dataTransform: root.invertedAxisTransform
        }
        QGLGraphItems.Ellipse {
            id: zeroWidthEllipse

            dataRect: Qt.rect(2, 3, 0, 4)
            dataTransform: root.invertedAxisTransform
        }
        QGLGraphItems.Ellipse {
            id: zeroHeightEllipse

            dataRect: Qt.rect(2, 3, 6, 0)
            dataTransform: root.invertedAxisTransform
        }
        QGLGraphItems.Ellipse {
            id: rotatedEllipse

            dataRect: Qt.rect(2, 3, 6, 4)
            dataTransform: root.rotationTransform
        }
        QGLGraphItems.Ellipse {
            id: shearedEllipse

            dataRect: Qt.rect(2, 3, 6, 4)
            dataTransform: root.shearTransform
        }
    }
}
