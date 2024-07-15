// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib

/*!
    \qmltype ColorMesh
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QuickGraphLib::ImageView
    \brief Display a colorized image from a 2D array.

    \note This graph item does not inherit from ShapePath, unlike other graph items.
*/

QuickGraphLib.ImageView {
    property rect _mappedExtents: dataTransform.mapRect(extents)
    /*!
        Must be assigned the data transform of the graph area this axis is paired to.
        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        The rect (in data coordinates) the image shall occupy. By default, the center of
        the top-left pixel is the origin (the 0, 0 point). Adjust this property to position
        or scale the image differently. By default, \l ImageView::mirrorHorizontally and
        \l ImageView::mirrorVertically sre set based on this property.
    */
    property rect extents: Qt.rect(-0.5, sourceSize.height - 0.5, sourceSize.width, -sourceSize.height)

    height: _mappedExtents.height
    mirrorHorizontally: extents.width < 0
    mirrorVertically: extents.height > 0
    width: _mappedExtents.width
    x: _mappedExtents.x
    y: _mappedExtents.y
}
