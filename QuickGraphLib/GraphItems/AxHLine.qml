// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS

/*!
    \qmltype AxHLine
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays a horizontal line.
*/

QQS.ShapePath {
    id: root

    readonly property point bottomRightPoint: dataTransform.map(Qt.point(viewRect.right, position))

    /*!
        Must be assigned the data transform of the graph area this axis is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        The Y position of the horizontal line in data coordinates.
    */
    required property double position
    readonly property point topLeftPoint: dataTransform.map(Qt.point(viewRect.left, position))
    /*!
        Must be assigned the view rect of the graph area this axis is paired to.

        \sa GraphArea::viewRect
    */
    required property rect viewRect

    startX: topLeftPoint.x
    startY: topLeftPoint.y

    PathLine {
        x: root.bottomRightPoint.x
        y: root.topLeftPoint.y
    }
}
