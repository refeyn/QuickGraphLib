// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    property var editablePoints: [Qt.point(1, 1.25), Qt.point(3.25, 4.75), Qt.point(6, 4), Qt.point(8.25, 1.75), Qt.point(4.5, 0.75)]
    property bool polygonSelected: true

    function moveEditablePoint(index, position) {
        let nextPoints = editablePoints.slice();
        nextPoints[index] = position;
        editablePoints = nextPoints;
    }
    function moveEditablePolygon(delta) {
        editablePoints = editablePoints.map(point => Qt.point(point.x + delta.x, point.y + delta.y));
    }

    viewRect: Qt.rect(-1, -1, 12, 8)
    xLabel: "X"
    yLabel: "Y"

    MouseArea {
        anchors.fill: parent

        onClicked: axes.polygonSelected = false
    }
    QGLGraphItems.Polygon {
        dataTransform: axes.dataTransform
        fillColor: "transparent"
        points: [Qt.point(1.5, 5), Qt.point(3.25, 6.35), Qt.point(5.5, 6), Qt.point(6.25, 4.9), Qt.point(3.6, 4.65)]
        strokeColor: "black"
        strokeWidth: 3
    }
    QGLGraphItems.Polygon {
        dataTransform: axes.dataTransform
        fillColor: "transparent"
        points: axes.editablePoints
        strokeColor: "black"
        strokeWidth: 1
    }
    QGLGraphItems.PolygonRoi {
        dataTransform: axes.dataTransform
        movable: true
        points: axes.editablePoints
        selectable: true
        selected: axes.polygonSelected

        onMoved: delta => axes.moveEditablePolygon(delta)
        onPointMoved: (index, position) => axes.moveEditablePoint(index, position)
        onSelectionRequested: axes.polygonSelected = true
    }
}
