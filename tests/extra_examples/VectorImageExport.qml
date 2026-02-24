pragma ComponentBehavior: Bound
// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT
// Tests for exporting Image items

import QtQuick
import QtQuick.Layouts as QQL
import QtQuick.VectorImage as QQV

Item {
    QQL.GridLayout {
        id: root

        property url source: "SVG_Logo.svg"

        anchors.fill: parent
        anchors.margins: 100
        columnSpacing: 10
        columns: 2
        rowSpacing: 10
        uniformCellHeights: true
        uniformCellWidths: true

        QQV.VectorImage {
            QQL.Layout.fillHeight: true
            QQL.Layout.fillWidth: true
            fillMode: QQV.VectorImage.NoResize
            source: root.source
        }
        QQV.VectorImage {
            QQL.Layout.fillHeight: true
            QQL.Layout.fillWidth: true
            fillMode: QQV.VectorImage.Stretch
            source: root.source
        }
        QQV.VectorImage {
            QQL.Layout.fillHeight: true
            QQL.Layout.fillWidth: true
            fillMode: QQV.VectorImage.PreserveAspectFit
            source: root.source
        }
        QQV.VectorImage {
            QQL.Layout.fillHeight: true
            QQL.Layout.fillWidth: true
            fillMode: QQV.VectorImage.PreserveAspectCrop
            source: root.source
        }
    }
}
