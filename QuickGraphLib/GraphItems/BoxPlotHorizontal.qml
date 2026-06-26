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
    required property double quartile0
    /*!
        The position of the Q1 line (first quartile) in data coordinates.
    */
    required property double quartile1
    /*!
        The position of the Q2 line (median) in data coordinates.
    */
    required property double quartile2
    /*!
        The position of the Q3 line (third quartile) in data coordinates.
    */
    required property double quartile3
    /*!
        The position of the Q4 whisker (maxiumum) in data coordinates.
    */
    required property double quartile4
    /*!
        The height of the whiskers in data coordinates.
    */
    required property double whiskerHeight

    pathHints: QQS.ShapePath.PathLinear | QQS.ShapePath.PathSolid

    PathMultiline {
        paths: [[root.dataTransform.map(Qt.point(root.quartile0, root.position + root.whiskerHeight / 2)), root.dataTransform.map(Qt.point(root.quartile0, root.position - root.whiskerHeight / 2))], [root.dataTransform.map(Qt.point(root.quartile0, root.position)), root.dataTransform.map(Qt.point(root.quartile1, root.position))]]
    }
    PathRectangle {
        readonly property point bottomRightPoint: root.dataTransform.map(Qt.point(root.quartile2, root.position - root.boxHeight / 2))
        readonly property point topLeftPoint: root.dataTransform.map(Qt.point(root.quartile1, root.position + root.boxHeight / 2))

        height: bottomRightPoint.y - topLeftPoint.y
        width: bottomRightPoint.x - topLeftPoint.x
        x: topLeftPoint.x
        y: topLeftPoint.y
    }
    PathRectangle {
        readonly property point bottomRightPoint: root.dataTransform.map(Qt.point(root.quartile3, root.position - root.boxHeight / 2))
        readonly property point topLeftPoint: root.dataTransform.map(Qt.point(root.quartile2, root.position + root.boxHeight / 2))

        height: bottomRightPoint.y - topLeftPoint.y
        width: bottomRightPoint.x - topLeftPoint.x
        x: topLeftPoint.x
        y: topLeftPoint.y
    }
    PathMultiline {
        paths: [[root.dataTransform.map(Qt.point(root.quartile3, root.position)), root.dataTransform.map(Qt.point(root.quartile4, root.position))], [root.dataTransform.map(Qt.point(root.quartile4, root.position + root.whiskerHeight / 2)), root.dataTransform.map(Qt.point(root.quartile4, root.position - root.whiskerHeight / 2))]]
    }
}
