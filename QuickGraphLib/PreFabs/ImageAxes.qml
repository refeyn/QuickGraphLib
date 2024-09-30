// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Layouts as QQL
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems

/*!
    \qmltype ImageAxes
    \inqmlmodule QuickGraphLib.PreFabs
    \inherits QuickGraphLib::AntialiasingContainer
    \brief Displays an image with axes and a colorbar.
*/

QuickGraphLib.AntialiasingContainer {
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
        An alias to the \l ColorMesh used to display the image.
    */
    property alias colorMesh: colormesh
    /*!
        An alias to the data transform of the graph area.

        \sa GraphArea::dataTransform
    */
    property alias dataTransform: grapharea.dataTransform
    /*!
        An alias the the GraphArea.
    */
    property alias grapharea: grapharea
    /*!
        Maximum number of ticks to show on the colorbar axis.

        \sa Helpers::tickLocator
    */
    property int numColorbarTicks: 5
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
        The title of the graph.
    */
    property alias title: titleLabel.text
    /*!
        An alias to the title item of the graph (a \l Text).
    */
    property alias titleItem: titleLabel
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

        anchors.fill: parent
        anchors.margins: 15
        columnSpacing: 0
        columns: 3
        rowSpacing: 0

        Text {
            id: titleLabel

            QQL.Layout.alignment: Qt.AlignCenter
            QQL.Layout.columnSpan: axes.columns
            visible: text !== ""
        }
        QuickGraphLib.Axis {
            id: yAxis

            QQL.Layout.fillHeight: true
            dataTransform: grapharea.dataTransform
            direction: QuickGraphLib.Axis.Direction.Left
            ticks: QuickGraphLib.Helpers.tickLocator(grapharea.effectiveViewRect.top, grapharea.effectiveViewRect.bottom, root.numYTicks)
        }
        QuickGraphLib.GraphArea {
            id: grapharea

            QQL.Layout.fillHeight: true
            QQL.Layout.fillWidth: true
            viewRect: colormesh.extents

            QGLGraphItems.ColorMesh {
                id: colormesh

                dataTransform: grapharea.dataTransform
            }
        }
        Item {
            implicitHeight: grapharea.height / 2
            implicitWidth: 70

            QQL.RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                spacing: -0.5

                Rectangle {
                    QQL.Layout.fillHeight: true
                    QQL.Layout.fillWidth: true
                    border.width: 1
                    rotation: 180

                    gradient: Gradient {
                        id: grad

                        property var colors: QuickGraphLib.ColorMaps.colors(root.colorMesh.colormap)

                        stops: colors.map((color, i) => gradStop.createObject(grad, {
                                        "color": color,
                                        "position": i / (colors.length - 1)
                                    }))
                    }
                }
                QuickGraphLib.Axis {
                    id: colorAxis

                    QQL.Layout.fillHeight: true
                    dataTransform: {
                        let mat = Qt.matrix4x4();
                        // Flip coordinate system so that Y points upwards
                        mat.translate(Qt.vector3d(0, height, 0));
                        mat.scale(1, -height / (colormesh.max - colormesh.min), 1);
                        mat.translate(Qt.vector3d(0, -colormesh.min, 0));
                        return mat;
                    }
                    direction: QuickGraphLib.Axis.Direction.Right
                    ticks: QuickGraphLib.Helpers.tickLocator(colormesh.min, colormesh.max, root.numColorbarTicks)
                }
            }
        }
        Item {
        }
        QuickGraphLib.Axis {
            id: xAxis

            QQL.Layout.fillWidth: true
            dataTransform: grapharea.dataTransform
            direction: QuickGraphLib.Axis.Direction.Bottom
            ticks: QuickGraphLib.Helpers.tickLocator(grapharea.effectiveViewRect.left, grapharea.effectiveViewRect.right, root.numXTicks)
        }
        Item {
        }
    }
    Component {
        id: gradStop

        GradientStop {
        }
    }
}
