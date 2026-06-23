// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS

/*!
    \qmltype BoxPLotVertical
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays a vertical box plot
*/
QQS.ShapePath {
    id: root

    /*!
        The width of the box in data coordinates.
    */
    required property double boxWidth

    /*!
        Must be assigned the data transform of the graph area this axis is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        The X position of the plot in data coordinates.
    */
    required property double position
    /*!
        The position of the Q0 whisker (minimum) in data coordinates.
    */
    required property double q0
    /*!
        The position of the Q1 line (first quartile) in data coordinates.
    */
    required property double q1
    /*!
        The position of the Q2 line (median) in data coordinates.
    */
    required property double q2
    /*!
        The position of the Q3 line (third quartile) in data coordinates.
    */
    required property double q3
    /*!
        The position of the Q4 whisker (maxiumum) in data coordinates.
    */
    required property double q4
    /*!
        The width of the whiskers in data coordinates.
    */
    required property double whiskerWidth

    pathHints: QQS.ShapePath.PathLinear | QQS.ShapePath.PathSolid

    PathMultiline {
        paths: [
            [
                root.dataTransform.map(Qt.point(root.position - root.whiskerWidth / 2, root.q4)),
                root.dataTransform.map(Qt.point(root.position + root.whiskerWidth / 2, root.q4))
            ],
            [
                root.dataTransform.map(Qt.point(root.position, root.q4)),
                root.dataTransform.map(Qt.point(root.position, root.q3))
            ]
        ]
    }
    PathRectangle {
        readonly property point bottomRightPoint: root.dataTransform.map(Qt.point(root.position + root.boxWidth / 2, root.q2))
        readonly property point topLeftPoint: root.dataTransform.map(Qt.point(root.position - root.boxWidth / 2, root.q3))

        height: bottomRightPoint.y - topLeftPoint.y
        width: bottomRightPoint.x - topLeftPoint.x
        x: topLeftPoint.x
        y: topLeftPoint.y
    }
    PathRectangle {
        readonly property point bottomRightPoint: root.dataTransform.map(Qt.point(root.position + root.boxWidth / 2, root.q1))
        readonly property point topLeftPoint: root.dataTransform.map(Qt.point(root.position - root.boxWidth / 2, root.q2))

        height: bottomRightPoint.y - topLeftPoint.y
        width: bottomRightPoint.x - topLeftPoint.x
        x: topLeftPoint.x
        y: topLeftPoint.y
    }
    PathMultiline {
        paths: [
            [
                root.dataTransform.map(Qt.point(root.position, root.q1)),
                root.dataTransform.map(Qt.point(root.position, root.q0))
            ],
            [
                root.dataTransform.map(Qt.point(root.position - root.whiskerWidth / 2, root.q0)),
                root.dataTransform.map(Qt.point(root.position + root.whiskerWidth / 2, root.q0))
            ]
        ]
    }
}
