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

    property var sierpinskiTriangles: QuickGraphLib.Helpers.range(0, 30).map(x => QuickGraphLib.Helpers.range(0, 30).map(y => x & y))

    columns: 2

    QQC.Label {
        QQL.Layout.fillWidth: true
        QQL.Layout.preferredWidth: 100
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        text: "magma"
    }
    QQC.Label {
        QQL.Layout.fillWidth: true
        QQL.Layout.preferredWidth: 100
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        text: "viridis"
    }
    QuickGraphLib.ImageView {
        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        colormap: "magma"
        max: 29
        source: root.sierpinskiTriangles
    }
    QuickGraphLib.ImageView {
        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        colormap: "viridis"
        max: 29
        source: root.sierpinskiTriangles
    }
    QQC.Label {
        QQL.Layout.fillWidth: true
        QQL.Layout.preferredWidth: 100
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        text: "twilight"
    }
    QQC.Label {
        QQL.Layout.fillWidth: true
        QQL.Layout.preferredWidth: 100
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        text: "turbo"
    }
    QuickGraphLib.ImageView {
        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        colormap: "twilight"
        max: 29
        source: root.sierpinskiTriangles
    }
    QuickGraphLib.ImageView {
        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        colormap: "turbo"
        max: 29
        source: root.sierpinskiTriangles
    }
}
