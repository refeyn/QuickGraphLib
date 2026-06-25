// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS

/*!
    \qmltype Rectangle
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays a rectangle in data coordinates.

    Draws a rectangle from a Qt rect in data coordinates. The style can be adjusted using the
    \l {ShapePath::fillColor} {fillColor}, \l {ShapePath::strokeColor} {strokeColor} and
    \l {ShapePath::strokeWidth} {strokeWidth} properties.
*/

QQS.ShapePath {
    id: root

    readonly property real dataBottom: Math.max(dataRect.y, dataRect.y + dataRect.height)
    readonly property real dataLeft: Math.min(dataRect.x, dataRect.x + dataRect.width)
    readonly property real dataRight: Math.max(dataRect.x, dataRect.x + dataRect.width)
    readonly property real dataTop: Math.min(dataRect.y, dataRect.y + dataRect.height)

    readonly property point mappedBottomLeft: dataTransform.map(Qt.point(dataLeft, dataBottom))
    readonly property point mappedBottomRight: dataTransform.map(Qt.point(dataRight, dataBottom))
    readonly property point mappedTopLeft: dataTransform.map(Qt.point(dataLeft, dataTop))
    readonly property point mappedTopRight: dataTransform.map(Qt.point(dataRight, dataTop))

    /*!
        Must be assigned the data transform of the graph area this rectangle is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        The rectangle in data coordinates.
    */
    required property rect dataRect

    fillColor: "transparent"
    joinStyle: QQS.ShapePath.RoundJoin
    pathHints: QQS.ShapePath.PathLinear | QQS.ShapePath.PathConvex | QQS.ShapePath.PathSolid
    startX: mappedTopLeft.x
    startY: mappedTopLeft.y

    PathLine {
        x: root.mappedTopRight.x
        y: root.mappedTopRight.y
    }
    PathLine {
        x: root.mappedBottomRight.x
        y: root.mappedBottomRight.y
    }
    PathLine {
        x: root.mappedBottomLeft.x
        y: root.mappedBottomLeft.y
    }
    PathLine {
        x: root.mappedTopLeft.x
        y: root.mappedTopLeft.y
    }
}
