// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype BaseHandles
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Item
    \internal
    \brief Shared base contract for graph handle overlays.

    BaseHandles centralizes the common styling, click and movement signal contract used by
    concrete handle overlay items. Applications should instantiate the concrete handle types rather
    than BaseHandles directly.
*/

Item {
    id: root

    property bool _bodyHovered: false

    /*!
        Must be assigned the data transform of the graph area this handle item is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        The normal handle fill color.
    */
    property color handleFillColor: "white"
    /*!
        The handle fill color used while hovered.
    */
    property color handleHoverFillColor: "#fff6bf"
    /*!
        The handle fill color used while selected or dragged.
    */
    property color handleSelectedFillColor: "#ffd24d"
    /*!
        The handle outline color.
    */
    property color handleStrokeColor: "#333333"
    /*!
        The handle outline width.
    */
    property real handleStrokeWidth: 1
    /*!
        Whether handles should be visible.
    */
    property bool handlesVisible: selected
    /*!
        Whether the pointer is currently over the shape body.
    */
    readonly property bool hovered: enabled && _bodyHovered
    /*!
        Whether the handle item should be drawn in the selected state.
    */
    property bool selected: false

    /*!
        Emitted when the body of the handle item is clicked.
    */
    signal bodyClicked

    /*!
        Emitted when \a handle is clicked.
    */
    signal handleClicked(GraphHandle handle)

    /*!
        Emitted when \a handle has moved to \a position in data coordinates.
    */
    signal handleMoved(GraphHandle handle, point position)
}
