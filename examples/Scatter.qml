// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

pragma ComponentBehavior: Bound
import QtQuick
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: xyaxes

    title: "10,000 points"
    viewRect: Qt.rect(-2, -2, 4, 4)

    Repeater {
        model: QuickGraphLib.Helpers.range(0, 10000).map(_ => [Math.sqrt(Math.random()) * 4 - 2, Math.sqrt(Math.random()) * 4 - 2])

        QGLGraphItems.Marker {
            required property var modelData

            color: "#22ff0000"
            dataTransform: xyaxes.dataTransform
            position: Qt.point(modelData[0], modelData[1])
            width: 10
        }
    }
}
