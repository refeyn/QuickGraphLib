// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    title: "Bar Chart (horizontal)"
    viewRect: Qt.rect(0, 0, 160, 400)
    xLabel: "Number of things"
    yLabel: "Position"
    xAxis.decimalPoints: 0
    yAxis.decimalPoints: 0

    QGLGraphItems.BarHorizontal {
        barHeight: 50
        barLength: 100
        dataTransform: axes.dataTransform
        fillColor: "#66ff0000"
        position: 100
        strokeColor: "black"
        strokeWidth: 1
    }
    QGLGraphItems.BarHorizontal {
        barHeight: 50
        barLength: 30
        dataTransform: axes.dataTransform
        fillColor: '#66ff7b00'
        position: 100
        strokeColor: "black"
        strokeStyle: QQS.ShapePath.DashLine
        strokeWidth: 1
    }
    QGLGraphItems.BarHorizontal {
        barHeight: 50
        barLength: 50
        dataTransform: axes.dataTransform
        fillColor: '#66ffd900'
        position: 100
        strokeColor: "black"
        strokeWidth: 1
    }
    QGLGraphItems.BarHorizontal {
        barHeight: 50
        barLength: 20
        dataTransform: axes.dataTransform
        fillColor: "#66ff0000"
        position: 300
        strokeColor: "black"
        strokeWidth: 1
    }
    QGLGraphItems.BarHorizontal {
        barHeight: 50
        barLength: 70
        dataTransform: axes.dataTransform
        fillColor: '#66ff7b00'
        position: 300
        strokeColor: "black"
        strokeStyle: QQS.ShapePath.DashLine
        strokeWidth: 1
    }
    QGLGraphItems.BarHorizontal {
        barHeight: 50
        barLength: 150
        dataTransform: axes.dataTransform
        fillColor: '#66ffd900'
        position: 300
        strokeColor: "black"
        strokeWidth: 1
    }
}
