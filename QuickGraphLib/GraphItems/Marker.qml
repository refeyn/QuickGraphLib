// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype Marker
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Rectangle
    \brief Displays a circular marker.

    \note This graph item does not inherit from ShapePath, unlike other graph items. This is for performance reasons.

    \sa {Scatter graph}
*/

Rectangle {
    id: root

    /*!
        Must be assigned the data transform of the graph area this axis is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    readonly property point pixelPosition: root.dataTransform.map(position)
    /*!
        The position of the marker in data coordinates.
    */
    required property point position

    border.width: 0
    height: width
    radius: width / 2
    width: 5
    x: pixelPosition.x - width / 2
    y: pixelPosition.y - width / 2
}
