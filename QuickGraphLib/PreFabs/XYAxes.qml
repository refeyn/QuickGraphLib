// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Layouts as QQL
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems

/*!
    \qmltype XYAxes
    \inqmlmodule QuickGraphLib.PreFabs
    \inherits Item
    \brief Displays an XY axis with a grid.

    \sa {Basic sin graph}, {Dark theme sin graph}, {Subgraphs}
*/

Item {
    id: root

    /*!
        An alias to the GridLayout that positions the graph area and individual axes.
    */
    property alias axes: axes
    /*!
        An alias to the \l Rectangle used as the background.
    */
    property alias background: background
    /*!
        The padding below the XYAxes
    */
    property int bottomPadding: 15
    /*!
        An alias to the data transform of the graph area.

        \sa GraphArea::dataTransform
    */
    property alias dataTransform: grapharea.dataTransform
    /*!
        An alias to the children of the graph area. Since this is the default property
        any declared children will be parented to the graph area.
    */
    default property alias graphChildren: grapharea.data
    /*!
        An alias the the GraphArea.
    */
    property alias grapharea: grapharea
    /*!
        An alias to the graph area's \l Grid.
    */
    property alias grid: grid
    /*!
        The padding to the left of the XYAxes
    */
    property int leftPadding: 15
    /*!
        Maximum number of ticks to show on the X axis.

        \sa Helpers::tickLocator
    */
    property int numXTicks: 11
    /*!
        Maximum number of ticks to show on the Y axis.

        \sa Helpers::tickLocator
    */
    property int numYTicks: 11
    /*!
        The padding to the right of the XYAxes
    */
    property int rightPadding: 15
    /*!
        The spacing between the title and the axes.
    */
    property double spacing: 0
    /*!
        The title of the graph.
    */
    property alias title: titleLabel.text
    /*!
        An alias to the title item of the graph (a \l Text).
    */
    property alias titleItem: titleLabel
    /*!
        The padding above the XYAxes
    */
    property int topPadding: 15
    /*!
        An alias to the view rect of the graph area.

        \sa GraphArea::viewRect
    */
    property alias viewRect: grapharea.viewRect
    /*!
        An alias to the X \l Axis.
    */
    property alias xAxis: xAxis
    /*!
        An alias to the X axis label.

        \sa Axis::label
    */
    property alias xLabel: xAxis.label
    /*!
        An alias to the Y \l Axis.
    */
    property alias yAxis: yAxis
    /*!
        An alias to the X axis label.

        \sa Axis::label
    */
    property alias yLabel: yAxis.label

    Rectangle {
        id: background

        anchors.fill: parent
        border.width: 0
    }
    QQL.GridLayout {
        id: axes

        anchors.bottomMargin: root.bottomPadding
        anchors.fill: parent
        anchors.leftMargin: root.leftPadding
        anchors.rightMargin: root.rightPadding
        anchors.topMargin: root.topPadding
        columnSpacing: 0
        columns: 2
        rowSpacing: 0

        Text {
            id: titleLabel

            QQL.Layout.alignment: Qt.AlignCenter
            QQL.Layout.bottomMargin: root.spacing
            QQL.Layout.columnSpan: axes.columns
            QQL.Layout.fillWidth: true
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
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
