// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS

/*!
    \qmltype Bar
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays a vertical bar for a bar graph.
*/
QQS.ShapePath {
    id: root

    /*!
        Must be assigned the data transform of the graph area this axis is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        The height of the bar in data coordinates.
    */
    required property double barHeight
    /*!
        The width of the bar in data coordinates.
    */
    required property double barWidth
    /*!
        The X position of the bar in data coordinates.
    */
    required property double position
    /*!
        The starting Y position of the bar in data coordinates.
    */
    property double yStart: 0

    pathHints: QQS.ShapePath.PathLinear | QQS.ShapePath.PathConvex | QQS.ShapePath.PathSolid
    PathRectangle {
        readonly property point bottomRightPoint: dataTransform.map(Qt.point(position+barWidth/2, barHeight >= 0 ? yStart : yStart - barHeight))
        readonly property point topLeftPoint: dataTransform.map(Qt.point(position-barWidth/2, barHeight >= 0 ? yStart + barHeight : yStart))
        x: topLeftPoint.x
        y: topLeftPoint.y
        width: bottomRightPoint.x - topLeftPoint.x
        height: bottomRightPoint.y - topLeftPoint.y

    }

}
