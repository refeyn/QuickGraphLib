// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype RoiHandleRepeater
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Item
    \brief Renders and wires a list of RoiHandle objects.
*/

Item {
    id: root

    /*!
        Must be assigned the data transform of the graph area this handle list is paired to.
    */
    required property matrix4x4 dataTransform
    /*!
        Handle configuration objects to render.
    */
    property list<RoiHandle> handles
    /*!
        Whether all handles should be selectable.
    */
    property bool selectable: true
    /*!
        Whether handles should use the selected visual state.
    */
    property bool selected: false
    /*!
        The normal handle fill color.
    */
    property color fillColor: "white"
    /*!
        The handle fill color used while hovered.
    */
    property color hoverFillColor: "#fff6bf"
    /*!
        The handle fill color used while selected or dragged.
    */
    property color selectedFillColor: "#ffd24d"
    /*!
        The handle outline color.
    */
    property color strokeColor: "#333333"
    /*!
        The handle outline width.
    */
    property real strokeWidth: 1

    /*!
        Emitted when \a handle requests selection.
    */
    signal handleSelectionRequested(RoiHandle handle)
    /*!
        Emitted when \a handle has moved to \a position in data coordinates.
    */
    signal handleMoved(RoiHandle handle, point position)

    x: 0
    y: 0
    width: parent ? parent.width : 0
    height: parent ? parent.height : 0

    Repeater {
        model: root.handles

        GraphHandle {
            required property RoiHandle modelData

            dataTransform: root.dataTransform
            delegate: modelData.delegate
            fillColor: root.fillColor
            hoverFillColor: root.hoverFillColor
            movable: modelData.movable
            position: modelData.position
            role: modelData.role
            selectable: root.selectable && modelData.selectable
            selected: root.selected || modelData.selected
            selectedFillColor: root.selectedFillColor
            shape: modelData.shape
            size: modelData.size
            strokeColor: root.strokeColor
            strokeWidth: root.strokeWidth
            visible: modelData.visible

            onMoved: position => root.handleMoved(modelData, position)
            onSelectionRequested: root.handleSelectionRequested(modelData)
        }
    }
}
