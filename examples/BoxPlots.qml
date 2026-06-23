// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    title: "Box plots"
    viewRect: Qt.rect(0, 0, 500, 500)
    xLabel: "X"
    yLabel: "Y"
    xAxis.decimalPoints: 0
    yAxis.decimalPoints: 0

    QGLGraphItems.BoxPlotVertical {
        boxWidth: 50
        dataTransform: axes.dataTransform
        fillColor: "green"
        position: 100
        q0: 20
        q1: 140
        q2: 190
        q3: 380
        q4: 400
        strokeColor: "darkgreen"
        strokeWidth: 3
        whiskerWidth: 25
    }
    QGLGraphItems.BoxPlotHorizontal {
        boxHeight: 50
        dataTransform: axes.dataTransform
        fillColor: "red"
        position: 250
        q0: 200
        q1: 270
        q2: 300
        q3: 320
        q4: 400
        strokeColor: "darkred"
        strokeStyle: QQS.ShapePath.DashLine
        strokeWidth: 7
        whiskerHeight: 150
    }
}
