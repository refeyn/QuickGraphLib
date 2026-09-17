// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts as QQL
import QuickGraphLib as QuickGraphLib

QQL.GridLayout {
    id: root

    property var sierpinskiTriangles: QuickGraphLib.Helpers.range(0, 32).map(x => QuickGraphLib.Helpers.range(0, 32).map(y => x & y))

    columns: 3

    QQC.Label {
        QQL.Layout.fillWidth: true
        QQL.Layout.preferredWidth: 100
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        text: "Magma"
    }
    QQC.Label {
        QQL.Layout.fillWidth: true
        QQL.Layout.preferredWidth: 100
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        text: "Viridis"
    }
    QQC.Label {
        QQL.Layout.fillWidth: true
        QQL.Layout.preferredWidth: 100
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        text: "Viridis (inverted)"
    }
    QuickGraphLib.ImageView {
        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        colormap: QuickGraphLib.ColorMaps.Magma
        source: root.sierpinskiTriangles
    }
    QuickGraphLib.ImageView {
        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        colormap: QuickGraphLib.ColorMaps.Viridis
        source: root.sierpinskiTriangles
    }
    QuickGraphLib.ImageView {
        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        colormap: QuickGraphLib.ColorMaps.Viridis
        invertColormap: true
        source: root.sierpinskiTriangles
    }
    QQC.Label {
        QQL.Layout.fillWidth: true
        QQL.Layout.preferredWidth: 100
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        text: "Twilight"
    }
    QQC.Label {
        QQL.Layout.fillWidth: true
        QQL.Layout.preferredWidth: 100
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        text: "Turbo"
    }
    QQC.Label {
        QQL.Layout.fillWidth: true
        QQL.Layout.preferredWidth: 100
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        text: "Custom"
    }
    QuickGraphLib.ImageView {
        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        colormap: QuickGraphLib.ColorMaps.Twilight
        source: root.sierpinskiTriangles
    }
    QuickGraphLib.ImageView {
        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        colormap: QuickGraphLib.ColorMaps.Turbo
        source: root.sierpinskiTriangles
    }
    QuickGraphLib.ImageView {
        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        source: root.sierpinskiTriangles

        colormap: Gradient {
            GradientStop {
                color: "red"
                position: 0.0
            }
            GradientStop {
                color: "yellow"
                position: 0.2
            }
            GradientStop {
                color: "green"
                position: 1.0
            }
        }
    }
}
