// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Layouts as QQL
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems

Item {
    id: root

    property double offset: 0

    Timer {
        interval: 1000 / 60
        repeat: true
        running: true

        onTriggered: root.offset += 1 / 60
    }
    Rectangle {
        anchors.fill: parent
        color: "gray"
    }
    QuickGraphLib.ScalingContainer {
        anchors.fill: parent
        contentHeight: 600
        contentWidth: 800

        Rectangle {
            anchors.fill: parent
            border.color: "black"
        }
        QQL.GridLayout {
            anchors.fill: parent
            anchors.margins: 12
            columnSpacing: 0
            columns: 2
            rowSpacing: 0

            QuickGraphLib.Axis {
                id: yAxis

                QQL.Layout.fillHeight: true
                dataTransform: grapharea.dataTransform
                direction: QuickGraphLib.Axis.Direction.Left
                ticks: QuickGraphLib.Helpers.linspace(-1.1, 1.1, 13)
            }
            QuickGraphLib.GraphArea {
                id: grapharea

                QQL.Layout.fillHeight: true
                QQL.Layout.fillWidth: true
                viewRect: Qt.rect(-20, -1.1, 760, 2.2)

                QGLGraphItems.Grid {
                    dataTransform: grapharea.dataTransform
                    strokeColor: "#11000000"
                    strokeWidth: 1
                    viewRect: grapharea.viewRect
                    xTicks: xAxis.ticks
                    yTicks: yAxis.ticks
                }
                QGLGraphItems.Line {
                    dataTransform: grapharea.dataTransform
                    path: QuickGraphLib.Helpers.linspace(0, 720, 100).map(x => Qt.point(x, Math.sin(x / 180 * Math.PI + root.offset)))
                    strokeColor: "red"
                    strokeWidth: 2
                }
            }
            Item {
            }
            QuickGraphLib.Axis {
                id: xAxis

                QQL.Layout.fillWidth: true
                dataTransform: grapharea.dataTransform
                decimalPoints: 0
                direction: QuickGraphLib.Axis.Direction.Bottom
                ticks: QuickGraphLib.Helpers.linspace(0, 720, 9)
            }
        }
    }
}
