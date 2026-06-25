// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    property var editablePoints: [
        Qt.point(1, 1),
        Qt.point(2.5, 4.5),
        Qt.point(4.5, 2),
        Qt.point(6.5, 5.5),
        Qt.point(8.5, 2.5)
    ]
    property bool polylineSelected: true

    viewRect: Qt.rect(-1, -1, 12, 8)
    xLabel: "X"
    yLabel: "Y"

    function moveEditablePolyline(delta) {
        editablePoints = editablePoints.map(point => Qt.point(point.x + delta.x, point.y + delta.y));
    }

    function moveEditablePoint(index, position) {
        let nextPoints = editablePoints.slice();
        nextPoints[index] = position;
        editablePoints = nextPoints;
    }

    MouseArea {
        anchors.fill: parent
        onClicked: axes.polylineSelected = false
    }
    QGLGraphItems.Polyline {
        dataTransform: axes.dataTransform
        points: [
            Qt.point(1, 6),
            Qt.point(3, 5.25),
            Qt.point(5, 6.5),
            Qt.point(8.5, 5.25)
        ]
        strokeColor: "#2ca02c"
        strokeWidth: 3
    }
    QGLGraphItems.Polyline {
        dataTransform: axes.dataTransform
        points: axes.editablePoints
        strokeColor: axes.polylineSelected ? "#d62728" : "#8c564b"
        strokeWidth: 4
    }
    QGLGraphItems.PolylineRoi {
        dataTransform: axes.dataTransform
        points: axes.editablePoints
        movable: true
        selectable: true
        selected: axes.polylineSelected

        onMoved: delta => axes.moveEditablePolyline(delta)
        onPointMoved: (index, position) => axes.moveEditablePoint(index, position)
        onSelectionRequested: axes.polylineSelected = true
    }
}
