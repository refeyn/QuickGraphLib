pragma ComponentBehavior: Bound
// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: root

    grid.strokeColor: "#20000000"
    grid.xTicks: QuickGraphLib.Helpers.linspace(-1, 1, 3)
    viewRect: Qt.rect(-1.6, -5.1, 3.2, 10.2)
    xAxis.decimalPoints: 0
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

    QGLGraphItems.Grid {
        // Minor grid ticks
        dataTransform: root.dataTransform
        strokeColor: "#09000000"
        strokeWidth: 1
        viewRect: root.viewRect
        xTicks: QuickGraphLib.Helpers.logspace(-2, 2, 5).slice(0, -1).map(x => QuickGraphLib.Helpers.linspace(x, x * 10, 11).slice(0, -1).map(xminor => Math.log10(xminor))).reduce((a, b) => a.concat(b), [])
        yTicks: root.grid.yTicks
    }
    QGLGraphItems.Line {
        dataTransform: root.dataTransform
        path: QuickGraphLib.Helpers.logspace(-1.5, 1.5, 1000).map(x => Qt.point(Math.log10(x), Math.tan(x)))
        strokeColor: "red"
    }
}
