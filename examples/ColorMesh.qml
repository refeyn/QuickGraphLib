// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    property var star: QuickGraphLib.Helpers.linspace(-4, 4, 80).map(y => QuickGraphLib.Helpers.linspace(-5, 5, 100).map(x => Math.sin(x * y) / 2 + 0.5))

    viewRect: colorMesh.extents

    QGLGraphItems.ColorMesh {
        id: colorMesh

        dataTransform: axes.dataTransform
        source: axes.star
    }
}
