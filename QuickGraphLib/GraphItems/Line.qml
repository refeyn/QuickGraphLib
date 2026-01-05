// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS
import QuickGraphLib as QuickGraphLib

/*!
    \qmltype Line
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays a line graph.

    Graph a line using a list of X,Y points. The style of the line can be adjusted using the
    \l {ShapePath::strokeColor} {strokeColor} and \l {ShapePath::strokeWidth} {strokeWidth} properties.

    \sa {Basic sin graph}

    \warning Using \l {ShapePath::fillColor} may result in incorrect rendering when using the CurveRenderer
    due to \l {https://qt-project.atlassian.net/browse/QTBUG-143112} {QTBUG-143112}. If this is a problem,
    use the GeometryRenderer instead. See \l {Antialiasing} for more information. \l {Histogram} has some
    workarounds built in to avoid this, so prefer using Histogram when possible.
*/

QQS.ShapePath {
    id: root

    /*!
        Must be assigned the data transform of the graph area this axis is paired to.

        \sa GraphArea::dataTransform
    */

    required property matrix4x4 dataTransform

    /*!
        Points to graph. Each point is a \l point (containing x and y coordinates) in the data space.
    */
    required property var path

    capStyle: QQS.ShapePath.RoundCap
    fillColor: "transparent"
    joinStyle: QQS.ShapePath.RoundJoin
    pathHints: QQS.ShapePath.PathLinear

    PathPolyline {
        path: QuickGraphLib.Helpers.mapPoints(root.path, root.dataTransform)
    }
}
