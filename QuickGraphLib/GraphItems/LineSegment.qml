// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS
import QuickGraphLib as QuickGraphLib

/*!
    \qmltype LineSegment
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays a finite line segment.

    Draws a line segment between two points in data coordinates. The style of the segment can be adjusted using the
    \l {ShapePath::strokeColor} {strokeColor} and \l {ShapePath::strokeWidth} {strokeWidth} properties.
*/

QQS.ShapePath {
    id: root

    /*!
        Must be assigned the data transform of the graph area this segment is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        The first endpoint in data coordinates.
    */
    required property point point1
    /*!
        The second endpoint in data coordinates.
    */
    required property point point2

    capStyle: QQS.ShapePath.RoundCap
    fillColor: "transparent"
    joinStyle: QQS.ShapePath.RoundJoin
    pathHints: QQS.ShapePath.PathLinear

    PathPolyline {
        path: QuickGraphLib.Helpers.mapPoints([root.point1, root.point2], root.dataTransform)
    }
}
