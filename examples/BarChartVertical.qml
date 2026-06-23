// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    title: "Bar Chart (vertical)"
    viewRect: Qt.rect(0, 0, 400, 160)
    xLabel: "Position"
    yLabel: "Number of things"
    xAxis.decimalPoints: 0
    yAxis.decimalPoints: 0

    QGLGraphItems.BarVertical {
        barHeight: 100
        barWidth: 50
        dataTransform: axes.dataTransform
        fillColor: "#66ff0000"
        position: 100
        strokeColor: "black"
        strokeWidth: 1
    }
    QGLGraphItems.BarVertical {
        barHeight: 30
        barWidth: 50
        dataTransform: axes.dataTransform
        fillColor: '#66ff7b00'
        position: 100
        strokeColor: "black"
        strokeStyle: QQS.ShapePath.DashLine
        strokeWidth: 1
    }
    QGLGraphItems.BarVertical {
        barHeight: 50
        barWidth: 50
        dataTransform: axes.dataTransform
        fillColor: '#66ffd900'
        position: 100
        strokeColor: "black"
        strokeWidth: 1
    }
    QGLGraphItems.BarVertical {
        barHeight: 20
        barWidth: 50
        dataTransform: axes.dataTransform
        fillColor: "#66ff0000"
        position: 300
        strokeColor: "black"
        strokeWidth: 1
    }
    QGLGraphItems.BarVertical {
        barHeight: 70
        barWidth: 50
        dataTransform: axes.dataTransform
        fillColor: '#66ff7b00'
        position: 300
        strokeColor: "black"
        strokeStyle: QQS.ShapePath.DashLine
        strokeWidth: 1
    }
    QGLGraphItems.BarVertical {
        barHeight: 150
        barWidth: 50
        dataTransform: axes.dataTransform
        fillColor: '#66ffd900'
        position: 300
        strokeColor: "black"
        strokeWidth: 1
    }
}
