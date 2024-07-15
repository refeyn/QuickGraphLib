// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts as QQL
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QQL.GridLayout {
    id: root

    property var sierpinskiTriangles: QuickGraphLib.Helpers.range(0, 32).map(x => QuickGraphLib.Helpers.range(0, 32).map(y => x & y))

    columns: 2

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
}
