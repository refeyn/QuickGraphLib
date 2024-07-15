// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts as QQL
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

Item {
    id: root

    property var values: {
        let vals = [];
        let index = 0;
        while (QuickGraphLib.ColorMaps.colorMapName(index) != "") {
            vals.push(index);
            ++index;
        }
        return vals;
    }

    QuickGraphLib.ScalingContainer {
        anchors.fill: parent
        contentHeight: grid.height
        contentWidth: grid.width

        QQL.GridLayout {
            id: grid

            columns: 2
            rows: root.values.length

            Repeater {
                model: root.values

                QQC.Label {
                    required property int index

                    QQL.Layout.column: 0
                    QQL.Layout.preferredWidth: 100
                    QQL.Layout.row: index
                    horizontalAlignment: Text.AlignRight
                    text: QuickGraphLib.ColorMaps.colorMapName(index)
                }
            }
            Repeater {
                model: root.values

                Rectangle {
                    id: delegate

                    required property int index

                    QQL.Layout.column: 1
                    QQL.Layout.row: index
                    border.width: 0
                    implicitHeight: 30
                    implicitWidth: 300

                    gradient: Gradient {
                        id: grad

                        property var colors: QuickGraphLib.ColorMaps.colors(delegate.index)

                        orientation: Gradient.Horizontal
                        stops: colors.map((color, i) => gradStop.createObject(grad, {
                                        "color": color,
                                        "position": i / (colors.length - 1)
                                    }))
                    }
                }
            }
        }
    }
    Component {
        id: gradStop

        GradientStop {
        }
    }
}
