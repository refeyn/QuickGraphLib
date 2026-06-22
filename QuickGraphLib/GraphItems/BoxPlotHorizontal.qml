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
        Must be assigned the data transform of the graph area this axis is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
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
        The width of the box in data coordinates.
    */
    required property double boxHeight
    /*!
        The width of the whiskers in data coordinates.
    */
    required property double whiskerHeight
    /*!
        The Y position of the plot in data coordinates.
    */
    required property double position


    pathHints: QQS.ShapePath.PathLinear | QQS.ShapePath.PathSolid
    PathMultiline {
        paths:  [
            [
                dataTransform.map(Qt.point(q0, position+whiskerHeight/2)),
                dataTransform.map(Qt.point(q0, position-whiskerHeight/2)),
            ],
            [
                dataTransform.map(Qt.point(q0, position)),
                dataTransform.map(Qt.point(q1, position)),
            ]
        ]
    }
    PathRectangle {
        readonly property point bottomRightPoint: dataTransform.map(Qt.point(q1, position+boxHeight/2))
        readonly property point topLeftPoint: dataTransform.map(Qt.point(q2, position-boxHeight/2))
        x: topLeftPoint.x
        y: topLeftPoint.y
        width: bottomRightPoint.x - topLeftPoint.x
        height: bottomRightPoint.y - topLeftPoint.y
    }
    PathRectangle {
        readonly property point bottomRightPoint: dataTransform.map(Qt.point(q2, position+boxHeight/2))
        readonly property point topLeftPoint: dataTransform.map(Qt.point(q3, position-boxHeight/2))
        x: topLeftPoint.x
        y: topLeftPoint.y
        width: bottomRightPoint.x - topLeftPoint.x
        height: bottomRightPoint.y - topLeftPoint.y
    }
    PathMultiline {
        paths:  [
            [
                dataTransform.map(Qt.point(q3, position)),
                dataTransform.map(Qt.point(q4, position)),
            ],
            [
                dataTransform.map(Qt.point(q4, position+whiskerHeight/2)),
                dataTransform.map(Qt.point(q4, position-whiskerHeight/2)),
            ]
            
        ]
    }
}
