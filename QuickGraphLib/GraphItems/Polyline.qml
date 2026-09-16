// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS
import QuickGraphLib as QuickGraphLib

/*!
    \qmltype Polyline
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays an open polyline in data coordinates.

    Draws connected line segments through a list of points in data coordinates. The style can be
    adjusted using the \l {ShapePath::strokeColor} {strokeColor} and
    \l {ShapePath::strokeWidth} {strokeWidth} properties.
*/

QQS.ShapePath {
    id: root

    /*!
        Must be assigned the data transform of the graph area this polyline is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        Points in data coordinates.
    */
    required property var points

    capStyle: QQS.ShapePath.RoundCap
    fillColor: "transparent"
    joinStyle: QQS.ShapePath.RoundJoin
    pathHints: QQS.ShapePath.PathLinear

    PathPolyline {
        path: QuickGraphLib.Helpers.mapPoints(root.points, root.dataTransform)
    }
}
