// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS

/*!
    \qmltype BarHorizontal
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays a horizontal bar for a bar graph.
*/
QQS.ShapePath {
    id: root

    /*!
        The height (Y) of the bar in data coordinates.
    */
    required property double barHeight
    /*!
        The length (X) of the bar in data coordinates.
    */
    required property double barLength

    /*!
        Must be assigned the data transform of the graph area this axis is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        The X position of the bar in data coordinates.
    */
    required property double position
    /*!
        The starting X position of the bar in data coordinates.
    */
    property double xStart: 0

    pathHints: QQS.ShapePath.PathLinear | QQS.ShapePath.PathConvex | QQS.ShapePath.PathSolid

    PathRectangle {
        readonly property point bottomRightPoint: dataTransform.map(Qt.point(barLength >= 0 ? xStart + barLength : xStart, position - barHeight / 2))
        readonly property point topLeftPoint: dataTransform.map(Qt.point(barLength >= 0 ? xStart : xStart + barLength, position + barHeight / 2))

        height: bottomRightPoint.y - topLeftPoint.y
        width: bottomRightPoint.x - topLeftPoint.x
        x: topLeftPoint.x
        y: topLeftPoint.y
    }
}
