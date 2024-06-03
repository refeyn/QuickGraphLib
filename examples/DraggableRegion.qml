// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
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
        id: span

        dataTransform: axes.dataTransform
        fillColor: spanMouseArea.containsMouse || spanMouseArea.dragging ? "#44ffff00" : "#44000000"
        viewRect: axes.viewRect
        xMax: axes.maxPos
        xMin: axes.minPos
    }
    QGLGraphItems.GraphItemDragHandler {
        id: spanMouseArea

        dataTransform: axes.dataTransform
        height: span.bottomRightPoint.y - span.topLeftPoint.y
        width: span.bottomRightPoint.x - span.topLeftPoint.x
        x: span.topLeftPoint.x
        y: span.topLeftPoint.y

        onMoved: position => {
            let x = Math.max(Math.min(position.x, 3 - position.width), -3);
            axes.maxPos = x + position.width;
            axes.minPos = x;
        }
    }
    QGLGraphItems.AxVLine {
        id: leftLine

        dataTransform: axes.dataTransform
        position: axes.minPos
        strokeColor: leftLineMouseArea.containsMouse || leftLineMouseArea.dragging ? "yellow" : "black"
        viewRect: axes.viewRect
    }
    QGLGraphItems.GraphItemDragHandler {
        id: leftLineMouseArea

        dataTransform: axes.dataTransform
        height: parent.height
        width: 40
        x: leftLine.topLeftPoint.x - width / 2

        onMoved: position => axes.minPos = Math.max(-3, Math.min(position.x + position.width / 2, axes.maxPos))
    }
    QGLGraphItems.AxVLine {
        id: rightLine

        dataTransform: axes.dataTransform
        position: axes.maxPos
        strokeColor: rightLineMouseArea.containsMouse || rightLineMouseArea.dragging ? "yellow" : "black"
        viewRect: axes.viewRect
    }
    QGLGraphItems.GraphItemDragHandler {
        id: rightLineMouseArea

        dataTransform: axes.dataTransform
        height: parent.height
        width: 40
        x: rightLine.topLeftPoint.x - width / 2

        onMoved: position => axes.maxPos = Math.min(3, Math.max(position.x + position.width / 2, axes.minPos))
    }
}
