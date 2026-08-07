// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    property var editablePoints: [Qt.point(1, 1), Qt.point(2.5, 4.5), Qt.point(4.5, 2), Qt.point(6.5, 5.5), Qt.point(8.5, 2.5)]
    property bool polylineSelected: true

    function moveEditablePoint(index, position) {
        let nextPoints = editablePoints.slice();
        nextPoints[index] = position;
        editablePoints = nextPoints;
    }
    function moveEditablePolyline(delta) {
        editablePoints = editablePoints.map(point => Qt.point(point.x + delta.x, point.y + delta.y));
    }

    viewRect: Qt.rect(-1, -1, 12, 8)
    xLabel: "X"
    yLabel: "Y"

    MouseArea {
        anchors.fill: parent

        onClicked: axes.polylineSelected = false
    }
    QGLGraphItems.Polyline {
        dataTransform: axes.dataTransform
        points: [Qt.point(1, 6), Qt.point(3, 5.25), Qt.point(5, 6.5), Qt.point(8.5, 5.25)]
        strokeColor: "black"
        strokeWidth: 3
    }
    QGLGraphItems.Polyline {
        id: editablePolyline

        dataTransform: axes.dataTransform
        points: axes.editablePoints
        strokeColor: "black"
        strokeWidth: 1
    }
    QGLGraphItems.PolylineHandles {
        dataTransform: axes.dataTransform
        movable: true
        points: axes.editablePoints
        selected: axes.polylineSelected

        onBodyClicked: axes.polylineSelected = true
        onHandleClicked: axes.polylineSelected = true
        onMoved: delta => axes.moveEditablePolyline(delta)
        onPointMoved: (index, position) => axes.moveEditablePoint(index, position)
    }
}
