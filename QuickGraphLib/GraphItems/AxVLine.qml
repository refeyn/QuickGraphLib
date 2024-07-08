// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS

/*!
    \qmltype AxVLine
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Rectangle
    \brief Displays an vertical line.
*/

QQS.ShapePath {
    id: root

    readonly property point bottomRightPoint: dataTransform.map(Qt.point(position, viewRect.top))

    /*!
        Must be assigned the data transform of the graph area this axis is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        The X position of the vertical line in data coordinates.
    */
    required property double position
    readonly property point topLeftPoint: dataTransform.map(Qt.point(position, viewRect.bottom))
    /*!
        Must be assigned the view rect of the graph area this axis is paired to.

        \sa GraphArea::viewRect
    */
    required property rect viewRect

    startX: topLeftPoint.x
    startY: topLeftPoint.y

    PathLine {
        x: root.topLeftPoint.x
        y: root.bottomRightPoint.y + root.strokeWidth
    }
}
