// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS
import QuickGraphLib as QuickGraphLib

/*!
    \qmltype Polygon
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays a closed polygon in data coordinates.

    Draws a closed polygon through a list of points in data coordinates. The style can be adjusted
    using the \l {ShapePath::fillColor} {fillColor}, \l {ShapePath::strokeColor} {strokeColor} and
    \l {ShapePath::strokeWidth} {strokeWidth} properties.
*/

QQS.ShapePath {
    id: root

    /*!
        Must be assigned the data transform of the graph area this polygon is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        Polygon vertices in data coordinates.
    */
    required property var points

    readonly property var closedPoints: {
        if (points.length === 0) return [];
        let nextPoints = points.slice();
        nextPoints.push(points[0]);
        return nextPoints;
    }

    fillColor: "transparent"
    joinStyle: QQS.ShapePath.RoundJoin
    pathHints: QQS.ShapePath.PathLinear | QQS.ShapePath.PathSolid

    PathPolyline {
        path: QuickGraphLib.Helpers.mapPoints(root.closedPoints, root.dataTransform)
    }
}
