// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd+other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts as QQL
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QQL.GridLayout {
    id: root

    property var face: [[0, 0, 0, 0, 0, 0, 0], [0, 0, 1, 0, 1, 0, 0], [0, 0, 1, 0, 1, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 1, 0, 0, 0, 1, 0], [0, 0, 1, 1, 1, 0, 0], [0, 0, 0, 0, 0, 0, 0],]

    columns: 5

    AlignedImage {
        QQL.Layout.columnSpan: 2
        QQL.Layout.row: 0
        fillMode: Qt.KeepAspectRatio
        text: "KeepAspectRatio+AlignCenter"
    }
    AlignedImage {
        QQL.Layout.columnSpan: 2
        QQL.Layout.row: 1
        alignment: Qt.AlignRight
        fillMode: Qt.KeepAspectRatio
        text: "KeepAspectRatio+AlignRight"
    }
    AlignedImage {
        QQL.Layout.column: 2
        QQL.Layout.rowSpan: 2
        alignment: Qt.AlignTop
        fillMode: Qt.KeepAspectRatio
        text: "KeepAspectRatio+AlignTop"
    }
    AlignedImage {
        QQL.Layout.column: 3
        QQL.Layout.rowSpan: 2
        alignment: Qt.AlignLeft
        fillMode: Qt.KeepAspectRatioByExpanding
        text: "KeepAspectRatioByExpanding+AlignLeft"
    }
    AlignedImage {
        QQL.Layout.column: 0
        QQL.Layout.row: 2
        text: "IgnoreAspectRatio"
    }
    AlignedImage {
        QQL.Layout.column: 1
        QQL.Layout.row: 2
        smooth: true
        text: "IgnoreAspectRatio+smooth"
    }
    AlignedImage {
        QQL.Layout.column: 2
        QQL.Layout.row: 2
        text: "IgnoreAspectRatio+transpose"
        transpose: true
    }
    AlignedImage {
        QQL.Layout.column: 3
        QQL.Layout.row: 2
        mirrorVertically: true
        text: "IgnoreAspectRatio+mirrorVertically"
    }

    component AlignedImage: Rectangle {
        property alias alignment: image.alignment
        property alias fillMode: image.fillMode
        property alias mirrorHorizontally: image.mirrorHorizontally
        property alias mirrorVertically: image.mirrorVertically
        property alias smooth: image.smooth
        property alias text: label.text
        property alias transpose: image.transpose

        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        border.width: 0
        color: "grey"

        QQL.ColumnLayout {
            anchors.fill: parent

            QQC.Label {
                id: label

                QQL.Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
            QuickGraphLib.ImageView {
                id: image

                QQL.Layout.fillHeight: true
                QQL.Layout.fillWidth: true
                clip: true
                source: root.face
            }
        }
    }
}
