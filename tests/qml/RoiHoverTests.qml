// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    property string activeShape: ""
    property bool completedSuccessfully: true
    readonly property bool ellipseHovered: ellipseHandles.hovered
    readonly property point ellipseInsidePoint: mapDataPoint(Qt.point(5, 4))
    readonly property point ellipseOutsidePoint: mapDataPoint(Qt.point(2.2, 2.2))
    property string failureMessage: ""
    readonly property bool lineHovered: lineHandles.hovered
    readonly property point lineInsidePoint: mapDataPoint(Qt.point(5, 5))
    readonly property point lineOutsidePoint: mapDataPoint(Qt.point(2, 8))
    readonly property bool polygonHovered: polygonHandles.hovered
    readonly property point polygonInsidePoint: mapDataPoint(Qt.point(5, 3))
    readonly property point polygonOutsidePoint: mapDataPoint(Qt.point(5, 0.5))
    readonly property bool polylineHovered: polylineHandles.hovered
    readonly property point polylineInsidePoint: mapDataPoint(Qt.point(3, 3))
    readonly property point polylineOutsidePoint: mapDataPoint(Qt.point(5, 2))
    readonly property bool rectangleHovered: rectangleHandles.hovered
    readonly property point rectangleInsidePoint: mapDataPoint(Qt.point(5, 4))
    readonly property point rectangleOutsidePoint: mapDataPoint(Qt.point(1, 4))

    function mapDataPoint(point) {
        return axes.mapFromItem(axes.grapharea, dataTransform.map(point));
    }

    height: 600
    viewRect: Qt.rect(0, 0, 10, 10)
    width: 800

    QGLGraphItems.LineSegmentHandles {
        id: lineHandles

        dataTransform: axes.dataTransform
        enabled: axes.activeShape === "line"
        point1: Qt.point(1, 1)
        point2: Qt.point(9, 9)
    }
    QGLGraphItems.PolylineHandles {
        id: polylineHandles

        dataTransform: axes.dataTransform
        enabled: axes.activeShape === "polyline"
        points: [Qt.point(1, 1), Qt.point(5, 5), Qt.point(9, 1)]
    }
    QGLGraphItems.PolygonHandles {
        id: polygonHandles

        dataTransform: axes.dataTransform
        enabled: axes.activeShape === "polygon"
        points: [Qt.point(1, 1), Qt.point(5, 5), Qt.point(9, 1)]
    }
    QGLGraphItems.EllipseHandles {
        id: ellipseHandles

        dataRect: Qt.rect(2, 2, 6, 4)
        dataTransform: axes.dataTransform
        enabled: axes.activeShape === "ellipse"
    }
    QGLGraphItems.RectangleHandles {
        id: rectangleHandles

        dataRect: Qt.rect(2, 2, 6, 4)
        dataTransform: axes.dataTransform
        enabled: axes.activeShape === "rectangle"
    }
}
