// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.ImageAxes {
    property var star: QuickGraphLib.Helpers.linspace(-4, 4, 80).map(y => QuickGraphLib.Helpers.linspace(-5, 5, 100).map(x => Math.sin(x * y)))

    colorMesh.source: star
}
