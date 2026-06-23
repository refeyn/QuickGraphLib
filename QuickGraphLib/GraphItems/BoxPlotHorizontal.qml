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
        The height of the box in data coordinates.
    */
    required property double boxHeight

    /*!
        Must be assigned the data transform of the graph area this axis is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        The Y position of the plot in data coordinates.
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
        The height of the whiskers in data coordinates.
    */
    required property double whiskerHeight

    pathHints: QQS.ShapePath.PathLinear | QQS.ShapePath.PathSolid

    PathMultiline {
        paths: [[dataTransform.map(Qt.point(q0, position + whiskerHeight / 2)), dataTransform.map(Qt.point(q0, position - whiskerHeight / 2))], [dataTransform.map(Qt.point(q0, position)), dataTransform.map(Qt.point(q1, position))]]
    }
    PathRectangle {
        readonly property point bottomRightPoint: dataTransform.map(Qt.point(q2, position - boxHeight / 2))
        readonly property point topLeftPoint: dataTransform.map(Qt.point(q1, position + boxHeight / 2))

        height: bottomRightPoint.y - topLeftPoint.y
        width: bottomRightPoint.x - topLeftPoint.x
        x: topLeftPoint.x
        y: topLeftPoint.y
    }
    PathRectangle {
        readonly property point bottomRightPoint: dataTransform.map(Qt.point(q3, position - boxHeight / 2))
        readonly property point topLeftPoint: dataTransform.map(Qt.point(q2, position + boxHeight / 2))

        height: bottomRightPoint.y - topLeftPoint.y
        width: bottomRightPoint.x - topLeftPoint.x
        x: topLeftPoint.x
        y: topLeftPoint.y
    }
    PathMultiline {
        paths: [[dataTransform.map(Qt.point(q3, position)), dataTransform.map(Qt.point(q4, position))], [dataTransform.map(Qt.point(q4, position + whiskerHeight / 2)), dataTransform.map(Qt.point(q4, position - whiskerHeight / 2))]]
    }
}
