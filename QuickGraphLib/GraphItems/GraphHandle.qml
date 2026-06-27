// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype GraphHandle
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Item
    \brief A draggable handle positioned in graph data coordinates.

    GraphHandle is an interaction helper for graph item editors. It renders a small handle at
    \l position and emits \l moved with the new data position when dragged.
*/

Item {
    id: root

    enum Role {
        Move,
        Resize,
        Rotate,
        Custom
    }
    enum Shape {
        Circle,
        Square
    }

    property point _pressOffset: Qt.point(0, 0)
    /*!
        The mouse cursor shown while hovering the handle.
    */
    property int cursorShape: Qt.SizeAllCursor

    /*!
        Must be assigned the data transform of the graph area this handle is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        Optional component used to replace the default handle visual.

        The delegate is loaded inside the handle and can read the handle state through
        \c parent.handle. For example, a delegate can bind to \c parent.handle.role,
        \c parent.handle.selected and \c parent.handle.dragging.
    */
    property Component delegate: null
    /*!
        Whether the handle is currently being dragged.
    */
    property bool dragging: false
    /*!
        The normal fill color.
    */
    property color fillColor: "white"
    /*!
        The mouse hit target size of the handle.
    */
    property real hitSize: size
    /*!
        The fill color used while hovered.
    */
    property color hoverFillColor: "#fff6bf"
    readonly property point mappedPosition: dataTransform.map(position)
    /*!
        Whether the handle can be dragged.
    */
    property bool movable: true
    /*!
        The handle position in data coordinates.
    */
    required property point position
    /*!
        The semantic editing role of the handle.

        This describes what the handle does. It is separate from \l shape, which only controls the
        default visual appearance.
    */
    property int role: GraphHandle.Custom
    /*!
        Whether pressing the handle should emit \l selectionRequested.
    */
    property bool selectable: true
    /*!
        Whether the handle should be drawn in the selected style.
    */
    property bool selected: false
    /*!
        The fill color used while selected or dragged.
    */
    property color selectedFillColor: "#ffd24d"
    /*!
        The rendered handle shape.
    */
    property int shape: GraphHandle.Circle
    /*!
        The visual size of the handle.
    */
    property real size: 12
    /*!
        The outline color.
    */
    property color strokeColor: "#333333"
    /*!
        The outline width.
    */
    property real strokeWidth: 1

    /*!
        Emitted when the handle has moved to \a position in data coordinates.
    */
    signal moved(point position)

    /*!
        Emitted when the handle requests selection.
    */
    signal selectionRequested

    height: hitSize
    width: hitSize
    x: mappedPosition.x - width / 2
    y: mappedPosition.y - height / 2

    Rectangle {
        anchors.centerIn: parent
        border.color: root.strokeColor
        border.width: root.strokeWidth
        color: root.dragging || root.selected ? root.selectedFillColor : mouseArea.containsMouse ? root.hoverFillColor : root.fillColor
        height: root.size
        radius: root.shape === GraphHandle.Circle ? root.size / 2 : 0
        visible: root.delegate === null
        width: root.size
    }
    Loader {
        property Item handle: root

        anchors.centerIn: parent
        height: root.size
        sourceComponent: root.delegate
        width: root.size
    }
    MouseArea {
        id: mouseArea

        anchors.fill: parent
        cursorShape: root.movable ? root.cursorShape : Qt.ArrowCursor
        hoverEnabled: true

        onCanceled: {
            root.dragging = false;
        }
        onPositionChanged: event => {
            if (!root.dragging || !root.movable)
                return;
            let parentPosition = Qt.point(root.x + event.x - root._pressOffset.x, root.y + event.y - root._pressOffset.y);
            root.moved(root.dataTransform.inverted().map(parentPosition));
        }
        onPressed: event => {
            root._pressOffset = Qt.point(event.x - root.width / 2, event.y - root.height / 2);
            root.dragging = true;
            if (root.selectable)
                root.selectionRequested();
        }
        onReleased: event => {
            root.dragging = false;
        }
    }
}
