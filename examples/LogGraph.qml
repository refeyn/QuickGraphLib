pragma ComponentBehavior: Bound
// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: root

    grid.xTicks: QuickGraphLib.Helpers.linspace(-1.5, 1.5, 11)
    viewRect: Qt.rect(-1.6, -5.1, 3.2, 10.2)
    xAxis.decimalPoints: 1
    xLabel: "x"
    yAxis.decimalPoints: 0
    yLabel: "tan(x)"

    xAxis.tickDelegate: QuickGraphLib.TickLabel {
        color: root.xAxis.tickLabelColor
        decimalPoints: root.xAxis.decimalPoints
        direction: root.xAxis.direction
        font: root.xAxis.tickLabelFont
        text: "10<sup>%1</sup>".arg(Number(value).toFixed(decimalPoints))
        textFormat: Text.RichText
    }

    QGLGraphItems.Line {
        dataTransform: root.dataTransform
        path: QuickGraphLib.Helpers.logspace(-1.5, 1.5, 1000).map(x => Qt.point(Math.log10(x), Math.tan(x)))
        strokeColor: "red"
    }
}
