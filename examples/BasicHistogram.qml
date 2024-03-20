// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    property double offset: 0

    title: "Normal distribution"
    viewRect: Qt.rect(-3, 0, 6, 0.5)
    xLabel: "Height"
    yLabel: "Frequency density"

    Timer {
        interval: 1000 / 60
        repeat: true
        running: true

        onTriggered: axes.offset += 1 / 60
    }
    QGLGraphItems.Histogram {
        bins: QuickGraphLib.Helpers.linspace(-3, 3, 61)
        dataTransform: axes.dataTransform
        fillColor: "#66ff0000"
        heights: QuickGraphLib.Helpers.range(0, bins.length - 1).map(i => (bins[i] + bins[i + 1]) / 2).map(x => Math.exp(-0.5 * x * x + Math.sin(axes.offset * 4)) / Math.sqrt(2 * Math.PI))
        strokeColor: "red"
        strokeWidth: 1
    }
    QGLGraphItems.AxVSpan {
        color: "#44000000"
        dataTransform: axes.dataTransform
        xMax: 0
        xMin: -1

        Text {
            anchors.centerIn: parent
            text: "34%"
        }
    }
    QGLGraphItems.AxVSpan {
        color: "#33000000"
        dataTransform: axes.dataTransform
        xMax: -1
        xMin: -2

        Text {
            anchors.centerIn: parent
            text: "13.5%"
        }
    }
    QGLGraphItems.AxVSpan {
        color: "#22000000"
        dataTransform: axes.dataTransform
        xMax: -2
        xMin: -3

        Text {
            anchors.centerIn: parent
            text: "2.35%"
        }
    }
}
