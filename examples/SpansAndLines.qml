// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    viewRect: Qt.rect(-5, -5, 10, 10)

    QGLGraphItems.AxVSpan {
        dataTransform: axes.dataTransform
        fillColor: "#44ff0000"
        viewRect: axes.viewRect
        xMax: -1
        xMin: -4
    }
    QGLGraphItems.AxVSpan {
        dataTransform: axes.dataTransform
        fillColor: "#4400ff00"
        strokeColor: "green"
        strokeWidth: 5
        viewRect: axes.viewRect
        xMax: 4
        xMin: 1
    }
    QGLGraphItems.AxVLine {
        dataTransform: axes.dataTransform
        position: 0.5
        strokeColor: "blue"
        strokeWidth: 5
        viewRect: axes.viewRect
    }
    QGLGraphItems.AxHSpan {
        dataTransform: axes.dataTransform
        fillColor: "#44ff00ff"
        viewRect: axes.viewRect
        yMax: -1
        yMin: -4
    }
    QGLGraphItems.AxHSpan {
        dataTransform: axes.dataTransform
        fillColor: "#4400ffff"
        strokeColor: "cyan"
        strokeWidth: 5
        viewRect: axes.viewRect
        yMax: 4
        yMin: 1
    }
    QGLGraphItems.AxHLine {
        dataTransform: axes.dataTransform
        position: 0.5
        strokeColor: "yellow"
        strokeWidth: 5
        viewRect: axes.viewRect
    }
}
