// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS
import QuickGraphLib as QuickGraphLib

/*!
    \qmltype Contours
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Draw a contour line or fill.
*/

QQS.ShapePath {
    id: root

    /*!
        Must be assigned the data transform of the graph area this axis is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        A list of list of points (or a list of \l {QPolygon}s) in data coordinates, with each list of points
        defining a contour line to draw.

        \sa ContourHelper::contourLine, ContourHelper::contourFill
    */
    required property var paths

    capStyle: QQS.ShapePath.RoundCap
    fillColor: "transparent"
    joinStyle: QQS.ShapePath.RoundJoin

    PathMultiline {
        paths: root.paths.map(ps => QuickGraphLib.Helpers.mapPoints(ps, root.dataTransform))
    }
}
