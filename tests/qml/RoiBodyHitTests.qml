// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    property bool completedSuccessfully: false
    property string failureMessage: ""

    height: 600
    viewRect: Qt.rect(0, 0, 10, 10)
    width: 800

    Component.onCompleted: {
        function assertPointClose(actual, expected, message) {
            if (Math.abs(actual.x - expected.x) > 0.001 || Math.abs(actual.y - expected.y) > 0.001) {
                throw new Error(message + ": expected " + expected + ", got " + actual);
            }
        }
        function assertBodyOrigin(roi, expected, message) {
            assertPointClose(roi._bodyScenePoint(Qt.point(0, 0)), expected, message);
        }
        function assertBodyLocalHit(roi, scenePoint, expected, message) {
            let origin = roi._bodyScenePoint(Qt.point(0, 0));
            let localPoint = Qt.point(scenePoint.x - origin.x, scenePoint.y - origin.y);
            if (roi._containsBodyPoint(localPoint) !== expected) {
                throw new Error(message);
            }
        }
        function assertBounds(roi, left, top, right, bottom, message) {
            if (roi._mappedLeft !== left || roi._mappedTop !== top || roi._mappedRight !== right || roi._mappedBottom !== bottom) {
                throw new Error(message);
            }
        }

        try {
            let lineDx = Math.abs(lineRoi._mappedPoint2.x - lineRoi._mappedPoint1.x);
            let lineDy = Math.abs(lineRoi._mappedPoint2.y - lineRoi._mappedPoint1.y);
            assertBodyOrigin(lineRoi, Qt.point(Math.min(lineRoi._mappedPoint1.x, lineRoi._mappedPoint2.x) - (Math.max(lineDx, lineRoi.hitWidth) - lineDx) / 2, Math.min(lineRoi._mappedPoint1.y, lineRoi._mappedPoint2.y) - (Math.max(lineDy, lineRoi.hitWidth) - lineDy) / 2), "line body local origin mismatch");
            assertBodyOrigin(polylineRoi, Qt.point(polylineRoi._mappedLeft - (Math.max(polylineRoi._mappedRight - polylineRoi._mappedLeft, polylineRoi.hitWidth) - (polylineRoi._mappedRight - polylineRoi._mappedLeft)) / 2, polylineRoi._mappedTop - (Math.max(polylineRoi._mappedBottom - polylineRoi._mappedTop, polylineRoi.hitWidth) - (polylineRoi._mappedBottom - polylineRoi._mappedTop)) / 2), "polyline body local origin mismatch");
            assertBodyOrigin(polygonRoi, Qt.point(polygonRoi._mappedLeft - polygonRoi.hitPadding, polygonRoi._mappedTop - polygonRoi.hitPadding), "polygon body local origin mismatch");
            assertBodyOrigin(ellipseRoi, Qt.point(Math.min(ellipseRoi._mappedLeftHandle.x, ellipseRoi._mappedRightHandle.x), Math.min(ellipseRoi._mappedTopHandle.y, ellipseRoi._mappedBottomHandle.y)), "ellipse body local origin mismatch");
            assertBodyOrigin(rectangleRoi, Qt.point(Math.min(rectangleRoi._mappedTopLeft.x, rectangleRoi._mappedTopRight.x, rectangleRoi._mappedBottomLeft.x, rectangleRoi._mappedBottomRight.x), Math.min(rectangleRoi._mappedTopLeft.y, rectangleRoi._mappedTopRight.y, rectangleRoi._mappedBottomLeft.y, rectangleRoi._mappedBottomRight.y)), "rectangle body local origin mismatch");

            let expectedPolygonPoints = polygonRoi.points.map(point => axes.dataTransform.map(point));
            if (polygonRoi._mappedPoints.length !== expectedPolygonPoints.length) {
                throw new Error("polygon mapped point count mismatch");
            }
            for (let index = 0; index < expectedPolygonPoints.length; ++index) {
                assertPointClose(polygonRoi._mappedPoints[index], expectedPolygonPoints[index], "polygon mapped point mismatch at index " + index);
                assertPointClose(polygonRoi.handles[index]._mappedPosition, expectedPolygonPoints[index], "polygon handle position mismatch at index " + index);
            }
            let polygonMappedXs = polygonRoi._mappedPoints.map(point => point.x);
            let polygonMappedYs = polygonRoi._mappedPoints.map(point => point.y);
            if (polygonRoi._mappedLeft !== Math.min(...polygonMappedXs) || polygonRoi._mappedRight !== Math.max(...polygonMappedXs) || polygonRoi._mappedTop !== Math.min(...polygonMappedYs) || polygonRoi._mappedBottom !== Math.max(...polygonMappedYs)) {
                throw new Error("polygon mapped bounds mismatch");
            }
            assertBounds(emptyPolygonRoi, 0, 0, 0, 0, "empty polygon mapped bounds mismatch");
            let singleMappedPoint = axes.dataTransform.map(singlePointPolygonRoi.points[0]);
            assertBounds(singlePointPolygonRoi, singleMappedPoint.x, singleMappedPoint.y, singleMappedPoint.x, singleMappedPoint.y, "single-point polygon mapped bounds mismatch");
            assertPointClose(singlePointPolygonRoi.handles[0]._mappedPosition, singleMappedPoint, "single-point polygon handle position mismatch");

            if (!lineRoi._containsBodyScenePoint(axes.dataTransform.map(Qt.point(5, 5)))) {
                throw new Error("line inside point missed");
            }
            if (lineRoi._containsBodyScenePoint(axes.dataTransform.map(Qt.point(2, 8)))) {
                throw new Error("line bounding-box point outside segment hit");
            }
            assertBodyLocalHit(lineRoi, axes.dataTransform.map(Qt.point(5, 5)), true, "line local inside point missed");
            assertBodyLocalHit(lineRoi, axes.dataTransform.map(Qt.point(2, 8)), false, "line local outside point hit");

            if (!polylineRoi._containsBodyScenePoint(axes.dataTransform.map(Qt.point(5, 5)))) {
                throw new Error("polyline inside point missed");
            }
            if (polylineRoi._containsBodyScenePoint(axes.dataTransform.map(Qt.point(5, 2)))) {
                throw new Error("polyline bounding-box point outside segments hit");
            }
            assertBodyLocalHit(polylineRoi, axes.dataTransform.map(Qt.point(5, 5)), true, "polyline local inside point missed");
            assertBodyLocalHit(polylineRoi, axes.dataTransform.map(Qt.point(5, 2)), false, "polyline local outside point hit");

            if (!polygonRoi._containsBodyScenePoint(axes.dataTransform.map(Qt.point(5, 3)))) {
                throw new Error("polygon inside point missed");
            }
            if (polygonRoi._containsBodyScenePoint(axes.dataTransform.map(Qt.point(5, 0.5)))) {
                throw new Error("polygon bounding-box point outside polygon hit");
            }
            assertBodyLocalHit(polygonRoi, axes.dataTransform.map(Qt.point(5, 3)), true, "polygon local inside point missed");
            assertBodyLocalHit(polygonRoi, axes.dataTransform.map(Qt.point(5, 0.5)), false, "polygon local outside point hit");

            if (!ellipseRoi._containsBodyScenePoint(axes.dataTransform.map(Qt.point(5, 4)))) {
                throw new Error("ellipse inside point missed");
            }
            if (ellipseRoi._containsBodyScenePoint(axes.dataTransform.map(Qt.point(2.2, 2.2)))) {
                throw new Error("ellipse bounding-box corner outside ellipse hit");
            }
            assertBodyLocalHit(ellipseRoi, axes.dataTransform.map(Qt.point(5, 4)), true, "ellipse local inside point missed");
            assertBodyLocalHit(ellipseRoi, axes.dataTransform.map(Qt.point(2.2, 2.2)), false, "ellipse local outside point hit");

            if (!rectangleRoi._containsBodyScenePoint(axes.dataTransform.map(Qt.point(5, 4)))) {
                throw new Error("rectangle inside point missed");
            }
            if (rectangleRoi._containsBodyScenePoint(axes.dataTransform.map(Qt.point(1, 4)))) {
                throw new Error("rectangle outside point hit");
            }
            assertBodyLocalHit(rectangleRoi, axes.dataTransform.map(Qt.point(5, 4)), true, "rectangle local inside point missed");
            assertBodyLocalHit(rectangleRoi, axes.dataTransform.map(Qt.point(1, 4)), false, "rectangle local outside point hit");
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
    QGLGraphItems.PolygonHandles {
        id: emptyPolygonRoi

        dataTransform: axes.dataTransform
        points: []
        selected: true
    }
    QGLGraphItems.PolygonHandles {
        id: singlePointPolygonRoi

        dataTransform: axes.dataTransform
        points: [Qt.point(3, 7)]
        selected: true
    }
    QGLGraphItems.EllipseHandles {
        id: ellipseRoi

        dataRect: Qt.rect(2, 2, 6, 4)
        dataTransform: axes.dataTransform
        selected: true
    }
    QGLGraphItems.RectangleHandles {
        id: rectangleRoi

        dataRect: Qt.rect(2, 2, 6, 4)
        dataTransform: axes.dataTransform
        selected: true
    }
}
