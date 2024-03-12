// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Shapes as QQS

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

    property list<point> _path: _calculateTickPath(ticks, direction, width, height, dataTransform)
    property list<int> _tickPositions
    /*!
        TODO
        \sa {GraphArea::dataTransform}
    */
    required property matrix4x4 dataTransform
    /*! TODO */
    property int decimalPoints: 2
    /*! TODO


        \value Axis.Direction.Left Axis to the left of the GraphArea
        \value Axis.Direction.Right Axis to the right of the GraphArea
        \value Axis.Direction.Top Axis above of the GraphArea
        \value Axis.Direction.Bottom Axis below of the GraphArea
     */
    required property int direction
    /*! TODO */
    property alias label: labelText.text
    /*! TODO */
    property bool showTickLabels: true
    /*! TODO */
    property double spacing: 4
    /*! TODO */
    property double tickLength: 10
    /*! TODO */
    required property list<double> ticks

    function _calculateTickPath(ticks, direction: int, width: double, height: double, dataTransform) {
        const longAxis = direction == Axis.Direction.Top || direction == Axis.Direction.Bottom ? width : height;
        let transformedTicks = ticks.map(t => dataTransform.map(Qt.point(t, t))[direction == Axis.Direction.Top || direction == Axis.Direction.Bottom ? "x" : "y"]);

        // Calculate everything as if we were a bottom axis
        let points = [Qt.point(0, 0)], tickPositions = [];
        transformedTicks.forEach(t => {
            if (t >= -0.5 && t <= longAxis + 0.5) {
                points.push(Qt.point(t, 0));
                points.push(Qt.point(t, root.tickLength));
                points.push(Qt.point(t, 0));
                tickPositions.push(points.length - 2);
            } else {
                tickPositions.push(-1);
            }
        });
        points.push(Qt.point(longAxis, 0));
        _tickPositions = tickPositions;

        // Transform into the correct positions
        switch (root.direction) {
        case Axis.Direction.Left:
            return points.map(p => Qt.point(width - p.y, p.x));
        case Axis.Direction.Right:
            return points.map(p => Qt.point(p.y, p.x));
        case Axis.Direction.Top:
            return points.map(p => Qt.point(p.x, height - p.y));
        case Axis.Direction.Bottom:
            return points;
        }
    }

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
            if (label != "") {
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
            if (label != "") {
                width += labelText.height + root.spacing;
            }
            return width;
        case Axis.Direction.Top:
        case Axis.Direction.Bottom:
            return 100;
        }
    }
    z: 1

    QQS.Shape {
        id: shape

        anchors.fill: parent

        QQS.ShapePath {
            id: myPath

            startX: root._path[0].x
            startY: root._path[0].y
            strokeColor: "black"
            strokeWidth: 1

            PathPolyline {
                path: root._path
            }
        }
    }
    Repeater {
        id: tickLabels

        model: root.showTickLabels ? root.ticks : []

        Text {
            required property int index
            required property double modelData

            leftPadding: 2
            rightPadding: 2
            text: Number(modelData).toFixed(root.decimalPoints)
            visible: root._tickPositions[index] >= 0
            x: {
                let baseX = root._path[root._tickPositions[index]]?.x ?? 0;
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
                let baseY = root._path[root._tickPositions[index]]?.y ?? 0;
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
