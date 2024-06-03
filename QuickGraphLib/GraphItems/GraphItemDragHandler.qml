// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype GraphItemDragHandler
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::MouseArea
    \brief Assists converting mouse drags into data positions.
*/

MouseArea {
    id: root

    property rect _startDragPos

    /*! TODO */
    required property matrix4x4 dataTransform
    /*! TODO */
    property bool dragging

    signal moved(rect position)

    hoverEnabled: true

    onPositionChanged: event => {
        if (dragging) {
            moved(dataTransform.inverted().mapRect(Qt.rect(root.x + event.x - _startDragPos.x, parent.y + root.y - _startDragPos.y, _startDragPos.width, _startDragPos.height)));
        }
    }
    onPressed: event => {
        _startDragPos = Qt.rect(mouseX, mouseY, width, height);
        dragging = true;
    }
    onReleased: event => {
        dragging = false;
    }
}
