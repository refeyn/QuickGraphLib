// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    title: "Bar Chart (vertical)"
    viewRect: Qt.rect(0, 0, 600, 200)
    xLabel: "Position"
    yLabel: "Number of things"

    QGLGraphItems.BarVertical {
        dataTransform: axes.dataTransform
        fillColor: "#66ff0000"
        strokeColor: "black"
        dashP
        strokeWidth: 1
        barHeight: 100
        barWidth: 50
        position: 100
    }
    QGLGraphItems.BarVertical {
        dataTransform: axes.dataTransform
        fillColor: '#66ff7b00'
        strokeColor: "black"
        strokeWidth: 1
        barHeight: 30
        barWidth: 50
        strokeStyle: QQC.ShapePath.DashLine
        position: 100
    }
    QGLGraphItems.BarVertical {
        dataTransform: axes.dataTransform
        fillColor: '#66ffd900'
        strokeColor: "black"
        strokeWidth: 1
        barHeight: 50
        barWidth: 50
        position: 100
    }

    QGLGraphItems.BarVertical {
        dataTransform: axes.dataTransform
        fillColor: "#66ff0000"
        strokeColor: "black"
        dashP
        strokeWidth: 1
        barHeight: 20
        barWidth: 50
        position: 500
    }
    QGLGraphItems.BarVertical {
        dataTransform: axes.dataTransform
        fillColor: '#66ff7b00'
        strokeColor: "black"
        strokeWidth: 1
        barHeight: 70
        barWidth: 50
        strokeStyle: QQC.ShapePath.DashLine
        position: 500
    }
    QGLGraphItems.BarVertical {
        dataTransform: axes.dataTransform
        fillColor: '#66ffd900'
        strokeColor: "black"
        strokeWidth: 1
        barHeight: 150
        barWidth: 50
        position: 500
    }
}
