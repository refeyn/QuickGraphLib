// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS

/*!
    \qmltype AxHSpan
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays a horizontal span.
*/

QQS.ShapePath {
    id: root

    readonly property point bottomRightPoint: dataTransform.map(Qt.point(viewRect.right, yMin))

    /*!
        Must be assigned the data transform of the graph area this axis is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    readonly property point topLeftPoint: dataTransform.map(Qt.point(viewRect.left, yMax))
    /*!
        Must be assigned the view rect of the graph area this axis is paired to.

        \sa GraphArea::viewRect
    */
    required property rect viewRect
    /*!
        The starting Y position of the horizontal span in data coordinates.
    */
    required property double yMax
    /*!
        The ending Y position of the horizontal span in data coordinates.
    */
    required property double yMin

    startX: topLeftPoint.x
    startY: topLeftPoint.y
    strokeColor: "transparent"

    PathLine {
        x: root.bottomRightPoint.x + root.strokeWidth
        y: root.topLeftPoint.y
    }
    // Would be much nicer to use PathMove, but then the whole rect is not filled
    PathLine {
        x: root.bottomRightPoint.x + root.strokeWidth
        y: root.bottomRightPoint.y
    }
    PathLine {
        x: root.topLeftPoint.x
        y: root.bottomRightPoint.y
    }
}
