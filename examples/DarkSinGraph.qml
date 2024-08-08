// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    background.color: "black"
    grid.strokeColor: "#33ffffff"
    viewRect: Qt.rect(-20, -1.1, 760, 2.2)
    xAxis.labelColor: "#ffaaaa"
    xAxis.labelFont.bold: true
    xAxis.strokeColor: "white"
    xAxis.tickLabelColor: "white"
    xAxis.tickLabelFont.italic: true
    xLabel: "Angle (°)"
    yAxis.labelColor: "#ffaaaa"
    yAxis.labelFont.bold: true
    yAxis.strokeColor: "white"
    yAxis.tickLabelColor: "white"
    yAxis.tickLabelFont.italic: true
    yLabel: "Value"

    QGLGraphItems.Line {
        id: sinLine

        dataTransform: axes.dataTransform
        path: QuickGraphLib.Helpers.linspace(0, 720, 100).map(x => Qt.point(x, Math.sin(x / 180 * Math.PI)))
        strokeColor: "red"
        strokeWidth: 2
    }
    QGLGraphItems.BasicLegend {
        anchors.margins: 10
        anchors.right: parent.right
        anchors.top: parent.top
        border.color: "white"
        color: "#33ffffff"

        QGLGraphItems.BasicLegendItem {
            strokeColor: sinLine.strokeColor
            text: "Sin(θ)"
            textColor: "white"
        }
    }
}
