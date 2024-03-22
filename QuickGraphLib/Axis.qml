// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
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
        TODO
        \sa {GraphArea::dataTransform}
    */
    property alias dataTransform: helper.dataTransform
    /*! TODO */
    property int decimalPoints: 2
    /*! TODO


        \value Axis.Direction.Left Axis to the left of the GraphArea
        \value Axis.Direction.Right Axis to the right of the GraphArea
        \value Axis.Direction.Top Axis above of the GraphArea
        \value Axis.Direction.Bottom Axis below of the GraphArea
     */
    property alias direction: helper.direction
    /*! TODO */
    property alias label: labelText.text
    /*! TODO */
    property alias labelColor: labelText.color
    /*! TODO */
    property alias labelFont: labelText.font
    /*! TODO */
    property bool showTickLabels: true
    /*! TODO */
    property double spacing: 4
    /*! TODO */
    property alias strokeColor: myPath.strokeColor
    /*! TODO */
    property alias strokeWidth: myPath.strokeWidth
    /*! TODO */
    property color tickLabelColor: labelColor
    /*! TODO */
    property font tickLabelFont: labelFont
    /*! TODO */
    property alias tickLength: helper.tickLength
    /*! TODO */
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
                height += root.tickLength + Math.max(0, ...[...Array(tickLabels.count).keys()].map(i => tickLabels.itemAt(i)?.height));
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
                width += root.tickLength + Math.max(0, ...[...Array(tickLabels.count).keys()].map(i => tickLabels.itemAt(i)?.width));
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
    Repeater {
        id: tickLabels

        model: root.showTickLabels ? root.ticks : []

        Text {
            required property int index
            required property double modelData

            color: root.tickLabelColor
            font: root.tickLabelFont
            leftPadding: 2
            rightPadding: 2
            text: Number(modelData).toFixed(root.decimalPoints)
            visible: helper.tickPositions[index].x !== -1
            x: {
                let baseX = helper.tickPositions[index].x;
                switch (root.direction) {
                case Axis.Direction.Left:
                    return baseX - width;
                case Axis.Direction.Right:
                    return baseX;
                case Axis.Direction.Top:
                    return baseX - width / 2;
                case Axis.Direction.Bottom:
                    return baseX - width / 2;
                }
            }
            y: {
                let baseY = helper.tickPositions[index].y;
                switch (root.direction) {
                case Axis.Direction.Left:
                    return baseY - height / 2;
                case Axis.Direction.Right:
                    return baseY - height / 2;
                case Axis.Direction.Top:
                    return baseY - height;
                case Axis.Direction.Bottom:
                    return baseY;
                }
            }
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
