// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    property rect editableEllipseRect: Qt.rect(1, 1.25, 4, 3)
    property bool ellipseSelected: true

    viewRect: Qt.rect(-1, -1, 12, 8)
    xLabel: "X"
    yLabel: "Y"

    function moveEditableEllipse(delta) {
        editableEllipseRect = Qt.rect(editableEllipseRect.x + delta.x, editableEllipseRect.y + delta.y, editableEllipseRect.width, editableEllipseRect.height);
    }

    MouseArea {
        anchors.fill: parent
        onClicked: axes.ellipseSelected = false
    }
    QGLGraphItems.Ellipse {
        dataRect: Qt.rect(6.5, 1.25, 2.75, 4)
        dataTransform: axes.dataTransform
        fillColor: "transparent"
        strokeColor: "black"
        strokeWidth: 3
    }
    QGLGraphItems.Ellipse {
        dataRect: axes.editableEllipseRect
        dataTransform: axes.dataTransform
        fillColor: "transparent"
        strokeColor: "black"
        strokeWidth: 4
    }
    QGLGraphItems.EllipseRoi {
        dataRect: axes.editableEllipseRect
        dataTransform: axes.dataTransform
        handleMode: QGLGraphItems.EllipseRoi.Cardinal
        movable: true
        selectable: true
        selected: axes.ellipseSelected

        onMoved: delta => axes.moveEditableEllipse(delta)
        onResized: dataRect => axes.editableEllipseRect = dataRect
        onSelectionRequested: axes.ellipseSelected = true
    }
}
