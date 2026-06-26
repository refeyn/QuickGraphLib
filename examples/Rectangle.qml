// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    property rect editableRect: Qt.rect(1, 1, 4, 3)
    property bool rectangleSelected: true

    viewRect: Qt.rect(-1, -1, 12, 8)
    xLabel: "X"
    yLabel: "Y"

    function moveEditableRectangle(delta) {
        editableRect = Qt.rect(editableRect.x + delta.x, editableRect.y + delta.y, editableRect.width, editableRect.height);
    }

    MouseArea {
        anchors.fill: parent
        onClicked: axes.rectangleSelected = false
    }
    QGLGraphItems.Rectangle {
        dataRect: Qt.rect(6.5, 1.25, 2.5, 4)
        dataTransform: axes.dataTransform
        fillColor: "transparent"
        strokeColor: "black"
        strokeWidth: 3
    }
    QGLGraphItems.Rectangle {
        dataRect: axes.editableRect
        dataTransform: axes.dataTransform
        fillColor: "transparent"
        strokeColor: "black"
        strokeWidth: 4
    }
    QGLGraphItems.RectangleRoi {
        dataRect: axes.editableRect
        dataTransform: axes.dataTransform
        handleMode: QGLGraphItems.RectangleRoi.Corners
        movable: true
        selectable: true
        selected: axes.rectangleSelected

        onMoved: delta => axes.moveEditableRectangle(delta)
        onResized: dataRect => axes.editableRect = dataRect
        onSelectionRequested: axes.rectangleSelected = true
    }
}
