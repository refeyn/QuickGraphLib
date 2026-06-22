// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    title: "Bar Chart (horizontal)"
    viewRect: Qt.rect(0, 0, 600, 200)
    xLabel: "Number of things"
    yLabel: "Position"

    QGLGraphItems.BarHorizontal {
        dataTransform: axes.dataTransform
        fillColor: "#66ff0000"
        strokeColor: "black"
        dashP
        strokeWidth: 1
        barLength: 100
        barHeight: 50
        position: 100
    }
    QGLGraphItems.BarHorizontal {
        dataTransform: axes.dataTransform
        fillColor: '#66ff7b00'
        strokeColor: "black"
        strokeWidth: 1
        barLength: 30
        barHeight: 50
        strokeStyle: QQC.ShapePath.DashLine
        position: 100
    }
    QGLGraphItems.BarHorizontal {
        dataTransform: axes.dataTransform
        fillColor: '#66ffd900'
        strokeColor: "black"
        strokeWidth: 1
        barLength: 50
        barHeight: 50
        position: 100
    }

    QGLGraphItems.BarHorizontal {
        dataTransform: axes.dataTransform
        fillColor: "#66ff0000"
        strokeColor: "black"
        dashP
        strokeWidth: 1
        barLength: 20
        barHeight: 50
        position: 500
    }
    QGLGraphItems.BarHorizontal {
        dataTransform: axes.dataTransform
        fillColor: '#66ff7b00'
        strokeColor: "black"
        strokeWidth: 1
        barLength: 70
        barHeight: 50
        strokeStyle: QQC.ShapePath.DashLine
        position: 500
    }
    QGLGraphItems.BarHorizontal {
        dataTransform: axes.dataTransform
        fillColor: '#66ffd900'
        strokeColor: "black"
        strokeWidth: 1
        barLength: 150
        barHeight: 50
        position: 500
    }
}
