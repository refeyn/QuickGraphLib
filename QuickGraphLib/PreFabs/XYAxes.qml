// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Layouts as QQL
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems

/*!
    \qmltype Line
    \inqmlmodule QuickGraphLib.PreFabs
    \inherits QuickGraphLib::AntialiasingContainer
    \brief Displays an XY axis with a grid.
*/

QuickGraphLib.AntialiasingContainer {
    id: root

    /*! TODO */
    property alias axes: axes
    /*! TODO */
    property alias background: background
    /*! TODO */
    property alias dataTransform: grapharea.dataTransform
    /*! TODO */
    default property alias graphChildren: grapharea.data
    /*! TODO */
    property alias grapharea: grapharea
    /*! TODO */
    property alias grid: grid
    /*! TODO */
    property int numXTicks: 11
    /*! TODO */
    property int numYTicks: 11
    /*! TODO */
    property alias title: titleLabel.text
    /*! TODO */
    property alias viewRect: grapharea.viewRect
    /*! TODO */
    property alias xAxis: xAxis
    /*! TODO */
    property alias xLabel: xAxis.label
    /*! TODO */
    property alias yAxis: yAxis
    /*! TODO */
    property alias yLabel: yAxis.label

    Rectangle {
        id: background

        anchors.fill: parent
        border.width: 0
    }
    QQL.GridLayout {
        id: axes

        anchors.fill: parent
        anchors.margins: 15
        columnSpacing: 0
        columns: 2
        rowSpacing: 0

        Text {
            id: titleLabel

            QQL.Layout.alignment: Qt.AlignCenter
            QQL.Layout.columnSpan: 2
            visible: text !== ""
        }
        QuickGraphLib.Axis {
            id: yAxis

            QQL.Layout.fillHeight: true
            dataTransform: grapharea.dataTransform
            direction: QuickGraphLib.Axis.Direction.Left
            ticks: grid.yTicks
        }
        QuickGraphLib.GraphArea {
            id: grapharea

            QQL.Layout.fillHeight: true
            QQL.Layout.fillWidth: true

            QGLGraphItems.Grid {
                id: grid

                dataTransform: grapharea.dataTransform
                strokeColor: "#11000000"
                strokeWidth: 1
                viewRect: grapharea.viewRect
                xTicks: QuickGraphLib.Helpers.tickLocator(grapharea.effectiveViewRect.left, grapharea.effectiveViewRect.right, root.numXTicks)
                yTicks: QuickGraphLib.Helpers.tickLocator(grapharea.effectiveViewRect.top, grapharea.effectiveViewRect.bottom, root.numYTicks)
            }
        }
        Item {
        }
        QuickGraphLib.Axis {
            id: xAxis

            QQL.Layout.fillWidth: true
            dataTransform: grapharea.dataTransform
            direction: QuickGraphLib.Axis.Direction.Bottom
            ticks: grid.xTicks
        }
    }
}
