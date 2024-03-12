// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    viewRect: Qt.rect(-5, -5, 10, 10)

    QGLGraphItems.AxVSpan {
        color: "#44ff0000"
        dataTransform: axes.dataTransform
        xMax: -1
        xMin: -4
    }
    QGLGraphItems.AxVSpan {
        border.color: "green"
        border.width: 5
        color: "#4400ff00"
        dataTransform: axes.dataTransform
        xMax: 4
        xMin: 1
    }
    QGLGraphItems.AxVLine {
        color: "blue"
        dataTransform: axes.dataTransform
        position: 0.5
        width: 5
    }
    QGLGraphItems.AxHSpan {
        color: "#44ff00ff"
        dataTransform: axes.dataTransform
        yMax: -1
        yMin: -4
    }
    QGLGraphItems.AxHSpan {
        border.color: "cyan"
        border.width: 5
        color: "#4400ffff"
        dataTransform: axes.dataTransform
        yMax: 4
        yMin: 1
    }
    QGLGraphItems.AxHLine {
        color: "yellow"
        dataTransform: axes.dataTransform
        height: 5
        position: 0.5
    }
}
