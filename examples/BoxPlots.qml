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
    QGLGraphItems.BoxPlotVertical {
        dataTransform: axes.dataTransform
        position: 100
        whiskerWidth: 25
        boxWidth: 50
        q0: 20
        q1: 140
        q2: 190
        q3: 380
        q4: 400
        fillColor: "green"
        strokeColor: "darkgreen"
        strokeWidth: 3
    }

    QGLGraphItems.BoxPlotHorizontal {
        dataTransform: axes.dataTransform
        position: 250
        whiskerHeight: 150
        boxWidth: 50
        q0: 200
        q1: 270
        q2: 30
        q3: 320
        q4: 400
        fillColor: "red"
        strokeColor: "darkred"
        strokeWidth: 7
        strokeStyle: QQS.ShapePath.DashLine
    }
    
}
