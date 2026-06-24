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
    xAxis.decimalPoints: 0
    yAxis.decimalPoints: 0

    QGLGraphItems.BoxPlotVertical {
        boxWidth: 50
        dataTransform: axes.dataTransform
        fillColor: "green"
        position: 100
        quartile0: 20
        quartile1: 140
        quartile2: 190
        quartile3: 380
        quartile4: 400
        strokeColor: "darkgreen"
        strokeWidth: 3
        whiskerWidth: 25
    }
    QGLGraphItems.BoxPlotHorizontal {
        boxHeight: 50
        dataTransform: axes.dataTransform
        fillColor: "red"
        position: 250
        quartile0: 200
        quartile1: 270
        quartile2: 300
        quartile3: 320
        quartile4: 400
        strokeColor: "darkred"
        strokeStyle: QQS.ShapePath.DashLine
        strokeWidth: 7
        whiskerHeight: 150
    }
}
