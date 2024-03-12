// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    property real maxPos: 0
    property real minPos: -2

    title: "Normal distribution"
    viewRect: Qt.rect(-3, 0, 6, 1)
    xLabel: "Height"
    yLabel: "Frequency density"

    QGLGraphItems.Histogram {
        bins: QuickGraphLib.Helpers.linspace(-3, 3, 61)
        dataTransform: axes.dataTransform
        fillColor: "#66ff0000"
        heights: QuickGraphLib.Helpers.linspace(-3, 3, 60).map(i => (Math.cos(i * Math.PI) + 0.9) / 2)
        strokeColor: "red"
        strokeWidth: 1
    }
    QGLGraphItems.AxVSpan {
        color: spanMouseArea.containsMouse || spanMouseArea.dragging ? "#44ffff00" : "#44000000"
        dataTransform: axes.dataTransform
        xMax: axes.maxPos
        xMin: axes.minPos

        QGLGraphItems.GraphItemDragHandler {
            id: spanMouseArea

            anchors.fill: parent
            dataTransform: axes.dataTransform

            onMoved: position => {
                let x = Math.max(Math.min(position.x, 3 - position.width), -3);
                axes.maxPos = x + position.width;
                axes.minPos = x;
            }
        }
    }
    QGLGraphItems.AxVLine {
        color: leftLineMouseArea.containsMouse || leftLineMouseArea.dragging ? "yellow" : "black"
        dataTransform: axes.dataTransform
        position: axes.minPos

        QGLGraphItems.GraphItemDragHandler {
            id: leftLineMouseArea

            anchors.centerIn: parent
            dataTransform: axes.dataTransform
            height: parent.height
            width: 40

            onMoved: position => axes.minPos = Math.max(-3, Math.min(position.x, axes.maxPos))
        }
    }
    QGLGraphItems.AxVLine {
        color: rightLineMouseArea.containsMouse || rightLineMouseArea.dragging ? "yellow" : "black"
        dataTransform: axes.dataTransform
        position: axes.maxPos

        QGLGraphItems.GraphItemDragHandler {
            id: rightLineMouseArea

            anchors.centerIn: parent
            dataTransform: axes.dataTransform
            height: parent.height
            width: 40

            onMoved: position => axes.maxPos = Math.min(3, Math.max(position.x, axes.minPos))
        }
    }
}
