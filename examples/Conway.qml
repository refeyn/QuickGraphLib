// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Layouts as QQL
import QtQuick.Dialogs as QQD
import QtQuick.Controls as QQC
import QuickGraphLib as QuickGraphLib
import examples.Conway as ConwayProvider

QQL.ColumnLayout {
    QQD.FileDialog {
        id: loadDialog

        fileMode: QQD.FileDialog.OpenFile
        nameFilters: ["RLE files (*.rle)", "All files (*)"]
        title: "Load RLE pattern"

        onAccepted: conwayProvider.loadFile(selectedFile)
    }
    Timer {
        interval: intervalSpin.value
        repeat: true
        running: runButton.checked

        onTriggered: conwayProvider.tick()
    }
    ConwayProvider.ConwayProvider {
        id: conwayProvider

    }
    QQL.RowLayout {
        QQC.Button {
            text: "Load pattern"

            onClicked: loadDialog.open()
        }
        QQC.Button {
            text: "Reset"

            onClicked: conwayProvider.reset()
        }
        QQC.Button {
            text: "Step"

            onClicked: conwayProvider.tick()
        }
        QQC.Button {
            id: runButton

            checkable: true
            text: checked ? "Pause" : "Run"
        }
        QQC.Button {
            text: "Rotate 90°"

            onClicked: conwayProvider.rot90()
        }
        Item {
            QQL.Layout.fillWidth: true
        }
        QQC.Label {
            text: "Display mode"
        }
        QQC.ComboBox {
            id: displayModeCombo

            model: [{
                    "value": "historyCells",
                    "text": "Cells with history"
                }, {
                    "value": "cells",
                    "text": "Cells"
                }, {
                    "value": "neighbourCounts",
                    "text": "Neighbour counts"
                }]
            textRole: "text"
            valueRole: "value"
        }
    }
    Item {
        QQL.Layout.fillHeight: true
        QQL.Layout.fillWidth: true
        clip: true

        QuickGraphLib.ZoomPanHandler {
            id: pinchArea

            anchors.fill: parent
        }
        QuickGraphLib.ImageView {
            anchors.fill: parent
            colormap: QuickGraphLib.ColorMaps.Magma
            fillMode: Qt.KeepAspectRatio
            source: conwayProvider[displayModeCombo.currentValue || "cells"]
            source1DSize: conwayProvider.size

            transform: Matrix4x4 {
                matrix: pinchArea.viewTransform
            }
        }
    }
    QQL.RowLayout {
        QQC.Label {
            text: "ms per tick"
        }
        QQC.SpinBox {
            id: intervalSpin

            editable: true
            from: 1
            to: 2000
            value: 100
        }
        QQC.Label {
            text: "Size"
        }
        QQC.SpinBox {
            id: widthSpin

            editable: true
            from: 1
            to: 2000
            value: conwayProvider.size.width

            onValueModified: conwayProvider.size = Qt.size(widthSpin.value, heightSpin.value)
        }
        QQC.Label {
            text: "x"
        }
        QQC.SpinBox {
            id: heightSpin

            editable: true
            from: 1
            to: 2000
            value: conwayProvider.size.height

            onValueModified: conwayProvider.size = Qt.size(widthSpin.value, heightSpin.value)
        }
        QQC.Label {
            text: "Rule B"
        }
        QQC.TextField {
            implicitWidth: 75
            maximumLength: 9
            text: conwayProvider.ruleB

            validator: RegularExpressionValidator {
                regularExpression: /[0-8]*/
            }

            onEditingFinished: conwayProvider.ruleB = text
        }
        QQC.Label {
            text: "/S"
        }
        QQC.TextField {
            implicitWidth: 75
            maximumLength: 9
            text: conwayProvider.ruleS

            validator: RegularExpressionValidator {
                regularExpression: /[0-8]*/
            }

            onEditingFinished: conwayProvider.ruleS = text
        }
    }
}
