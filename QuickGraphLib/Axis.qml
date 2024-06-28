// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Shapes as QQS
import QuickGraphLib as QuickGraphLib

/*!
    \qmltype Axis
    \inqmlmodule QuickGraphLib
    \inherits QtQuick::Item
    \brief Displays an Axis.
*/

Item {
    id: root

    enum Direction {
        Left,
        Right,
        Top,
        Bottom
    }

    /*!
        Must be assigned the data transform of the graph area this axis is paired to.

        \sa GraphArea::dataTransform
    */
    property alias dataTransform: helper.dataTransform
    /*!
        Number of decimal points the ticks should show.

        \sa TickLabel::decimalPoints
    */
    property int decimalPoints: 2
    /*!
        The side of the graph the Axis is on. It can take one of the following values:

        \value Axis.Direction.Left Axis to the left of the GraphArea
        \value Axis.Direction.Right Axis to the right of the GraphArea
        \value Axis.Direction.Top Axis above of the GraphArea
        \value Axis.Direction.Bottom Axis below of the GraphArea
     */
    property alias direction: helper.direction
    /*!
        The label text for this axis. Alias of \c labelItem.text.
    */
    property alias label: labelText.text
    /*!
        The color of the label. Alias of \c labelItem.color.
    */
    property alias labelColor: labelText.color
    /*!
        The font of the label. Alias of \c labelItem.font.
    */
    property alias labelFont: labelText.font
    /*!
        The axis label (a \l Text).
    */
    property alias labelItem: labelText
    /*!
        Whether to show a label for each tick.
    */
    property bool showTickLabels: true
    /*!
        Spacing between the end of each tick and the tick label.
    */
    property double spacing: 4
    /*!
        Color of the axis spine and ticks.
    */
    property alias strokeColor: myPath.strokeColor
    /*!
        Width of the axis spine and ticks.
    */
    property alias strokeWidth: myPath.strokeWidth
    /*!
        The component used for rendering tick labels. If overridden,
        the \c color, \c decimalPoints, \c direction, and \c font properties
        of the component should be set explicitly. To get proper positioning,
        it is recommended that \l TickLabel or a subclass is used.
    */
    property Component tickDelegate: TickLabel {
        color: root.labelColor
        decimalPoints: root.decimalPoints
        direction: root.direction
        font: root.labelFont
    }
    /*!
        The color of the tick labels.
    */
    property color tickLabelColor: labelColor
    /*!
        The font of the tick labels.
    */
    property font tickLabelFont: labelFont
    /*!
        The length of each tick.
    */
    property alias tickLength: helper.tickLength
    /*!
        The position of each tick. This should be a list of doubles in data coordinates.

        \sa Helpers::range, Helpers::linspace, Grid::xTicks, Grid::yTicks
    */
    property alias ticks: helper.ticks

    implicitHeight: {
        switch (root.direction) {
        case Axis.Direction.Left:
        case Axis.Direction.Right:
            return 100;
        case Axis.Direction.Top:
        case Axis.Direction.Bottom:
            let height = 0;
            if (ticks.length > 0) {
                // Can't use childrenRect due to the binding loop it causes
                height += root.tickLength + Math.max(0, ...tickLabelsContainer.children.map(x => x.height));
            }
            if (label !== "") {
                height += labelText.height + root.spacing;
            }
            return height;
        }
    }
    implicitWidth: {
        switch (root.direction) {
        case Axis.Direction.Left:
        case Axis.Direction.Right:
            let width = 0;
            if (ticks.length > 0) {
                // Can't use childrenRect due to the binding loop it causes
                width += root.tickLength + Math.max(0, ...tickLabelsContainer.children.map(x => x.width));
            }
            if (label !== "") {
                width += labelText.height + root.spacing;
            }
            return width;
        case Axis.Direction.Top:
        case Axis.Direction.Bottom:
            return 100;
        }
    }
    z: 1

    QuickGraphLib.AxisHelper {
        id: helper

        height: root.height
        tickLength: 10
        width: root.width
    }
    QQS.Shape {
        id: shape

        anchors.fill: parent

        QQS.ShapePath {
            id: myPath

            strokeColor: "black"
            strokeWidth: 1

            PathPolyline {
                path: helper.path
            }
        }
    }
    Item {
        id: tickLabelsContainer

        Repeater {
            delegate: root.tickDelegate
            model: root.showTickLabels ? helper.tickModel : null
        }
    }
    Text {
        id: labelText

        x: {
            switch (root.direction) {
            case Axis.Direction.Left:
                return height / 2;
            case Axis.Direction.Right:
                return root.width - height / 2;
            case Axis.Direction.Top:
            case Axis.Direction.Bottom:
                return root.width / 2;
            }
        }
        y: {
            switch (root.direction) {
            case Axis.Direction.Left:
            case Axis.Direction.Right:
                return root.height / 2;
            case Axis.Direction.Top:
                return height / 2;
            case Axis.Direction.Bottom:
                return root.height - height / 2;
            }
        }

        transform: [
            Translate {
                x: -labelText.width / 2
                y: -labelText.height / 2
            },
            Rotation {
                angle: {
                    switch (root.direction) {
                    case Axis.Direction.Left:
                        return -90;
                    case Axis.Direction.Right:
                        return 90;
                    case Axis.Direction.Top:
                    case Axis.Direction.Bottom:
                        return 0;
                    }
                }
            }
        ]
    }
}
