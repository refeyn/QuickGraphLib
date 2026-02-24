pragma ComponentBehavior: Bound
// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT
// Tests for exporting Image items

import QtQuick
import QtQuick.Layouts as QQL

QQL.GridLayout {
    id: root

    property url source: "500px-Kittyply_edit1.jpg"

    columnSpacing: 10
    columns: 3
    rowSpacing: 10
    uniformCellHeights: true
    uniformCellWidths: true

    Image {
        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        fillMode: Image.Stretch
        source: root.source
    }
    Image {
        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        fillMode: Image.PreserveAspectFit
        source: root.source
    }
    Image {
        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        fillMode: Image.PreserveAspectCrop
        source: root.source
    }
    Image {
        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        fillMode: Image.Pad
        source: root.source
        sourceSize: Qt.size(100, 100)
    }
    Image {
        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        fillMode: Image.Pad
        horizontalAlignment: Image.AlignLeft
        source: root.source
        sourceSize: Qt.size(100, 100)
        verticalAlignment: Image.AlignTop
    }
    Image {
        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        fillMode: Image.Pad
        horizontalAlignment: Image.AlignRight
        source: root.source
        sourceSize: Qt.size(100, 100)
        verticalAlignment: Image.AlignBottom
    }
}
