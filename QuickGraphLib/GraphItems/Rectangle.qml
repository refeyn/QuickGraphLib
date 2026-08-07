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

    readonly property real _dataBottom: Math.max(dataRect.y, dataRect.y + dataRect.height)
    readonly property real _dataLeft: Math.min(dataRect.x, dataRect.x + dataRect.width)
    readonly property real _dataRight: Math.max(dataRect.x, dataRect.x + dataRect.width)
    readonly property real _dataTop: Math.min(dataRect.y, dataRect.y + dataRect.height)
    // Map corners independently so non-axis-aligned transforms preserve the rectangle geometry.
    readonly property point _mappedBottomLeft: dataTransform.map(Qt.point(_dataLeft, _dataBottom))
    readonly property point _mappedBottomRight: dataTransform.map(Qt.point(_dataRight, _dataBottom))
    readonly property point _mappedTopLeft: dataTransform.map(Qt.point(_dataLeft, _dataTop))
    readonly property point _mappedTopRight: dataTransform.map(Qt.point(_dataRight, _dataTop))
    /*!
        The rectangle in data coordinates.
    */
    required property rect dataRect

    /*!
        Must be assigned the data transform of the graph area this rectangle is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform

    fillColor: "transparent"
    joinStyle: QQS.ShapePath.RoundJoin
    pathHints: QQS.ShapePath.PathLinear | QQS.ShapePath.PathConvex | QQS.ShapePath.PathSolid
    startX: _mappedTopLeft.x
    startY: _mappedTopLeft.y

    PathLine {
        x: root._mappedTopRight.x
        y: root._mappedTopRight.y
    }
    PathLine {
        x: root._mappedBottomRight.x
        y: root._mappedBottomRight.y
    }
    PathLine {
        x: root._mappedBottomLeft.x
        y: root._mappedBottomLeft.y
    }
    PathLine {
        x: root._mappedTopLeft.x
        y: root._mappedTopLeft.y
    }
}
