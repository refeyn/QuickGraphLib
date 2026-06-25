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
    xAxis.decimalPoints: 0
    xLabel: "Position"
    yAxis.decimalPoints: 0
    yLabel: "Number of things"

    QGLGraphItems.BarVertical {
        barHeight: 100
        barWidth: 50
        dataTransform: axes.dataTransform
        fillColor: '#d10a0a'
        position: 100
        strokeColor: "black"
        strokeWidth: 1
    }
    QGLGraphItems.BarVertical {
        barHeight: 30
        barWidth: 50
        dataTransform: axes.dataTransform
        fillColor: '#cf6808'
        position: 100
        strokeColor: "black"
        strokeStyle: QQS.ShapePath.DashLine
        strokeWidth: 1
        yStart: 100
    }
    QGLGraphItems.BarVertical {
        barHeight: 50
        barWidth: 50
        dataTransform: axes.dataTransform
        fillColor: '#e7c609'
        position: 100
        strokeColor: "black"
        strokeWidth: 1
        yStart: 130
    }
    QGLGraphItems.BarVertical {
        barHeight: 20
        barWidth: 50
        dataTransform: axes.dataTransform
        fillColor: '#d10a0a'
        position: 300
        strokeColor: "black"
        strokeWidth: 1
    }
    QGLGraphItems.BarVertical {
        barHeight: 70
        barWidth: 50
        dataTransform: axes.dataTransform
        fillColor: '#cf6808'
        position: 300
        strokeColor: "black"
        strokeStyle: QQS.ShapePath.DashLine
        strokeWidth: 1
        yStart: 20
    }
    QGLGraphItems.BarVertical {
        barHeight: 150
        barWidth: 50
        dataTransform: axes.dataTransform
        fillColor: '#e7c609'
        position: 300
        strokeColor: "black"
        strokeWidth: 1
        yStart: 90
    }
}
