// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    // Note the reversed signs compared to the normal sin graph
    viewRect: Qt.rect(100, 100, -200, -200)
    xAxis.decimalPoints: 0
    yAxis.decimalPoints: 0

    QGLGraphItems.Line {
        dataTransform: axes.dataTransform
        path: QuickGraphLib.Helpers.linspace(80, -80, 100).map(x => Qt.point(x, x))
        strokeColor: "red"
        strokeWidth: 2
    }
}
