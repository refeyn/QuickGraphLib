// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib

/*!
    \qmltype PolylineHandles
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Item
    \brief Interaction overlay for an open polyline region of interest.

    PolylineHandles provides selection, body dragging and vertex handles for a list of points. It does
    not own the point data; instead it emits movement signals so applications can update their own
    model.
*/

BaseHandles {
    id: root

    property bool _bodyDragging: false
    property point _lastDragPoint: Qt.point(0, 0)
    readonly property real _mappedBottom: _mappedPoints.length === 0 ? 0 : Math.max(..._mappedPoints.map(point => point.y))
    readonly property real _mappedLeft: _mappedPoints.length === 0 ? 0 : Math.min(..._mappedPoints.map(point => point.x))
    readonly property var _mappedPoints: points.map(point => dataTransform.map(point))
    readonly property real _mappedRight: _mappedPoints.length === 0 ? 0 : Math.max(..._mappedPoints.map(point => point.x))
    readonly property real _mappedTop: _mappedPoints.length === 0 ? 0 : Math.min(..._mappedPoints.map(point => point.y))
    /*!
        The mouse hit target size of vertex handles.
    */
    property real handleHitSize: 24
    /*!
        The visual size and hit target size of vertex handles.
    */
    property real handleSize: 8
    /*!
        GraphHandle objects rendered by this item.
    */
    readonly property var handles: vertexHandleRepeater._items
    /*!
        The body hit target width in pixels.
    */
    property real hitWidth: 18
    /*!
        Whether dragging the polyline body should emit movement signals.
    */
    property bool movable: true
    /*!
        Points in data coordinates.
    */
    required property var points
    /*!
        Optional visual delegate used for vertex handles.

        The delegate can read the handle state through \c parent.handle.
    */
    property Component vertexHandleDelegate: null
    /*!
        The default shape used for vertex resize handles.
    */
    property int vertexHandleShape: GraphHandle.Circle
    /*!
        Whether vertex handles can move individual points.
    */
    property bool vertexHandlesMovable: true

    /*!
        Emitted when the polyline body has moved by \a delta in data coordinates.
    */
    signal moved(point delta)
    /*!
        Emitted when point \a index has moved to \a position in data coordinates.
    */
    signal pointMoved(int index, point position)

    function _bodyScenePoint(localPoint) {
        return root.mapFromItem(bodyMouseArea, localPoint);
    }
    function _containsBodyPoint(localPoint) {
        return _containsBodyScenePoint(_bodyScenePoint(localPoint));
    }
    function _containsBodyScenePoint(scenePoint) {
        return QuickGraphLib.Helpers.isNearPolyline(scenePoint, _mappedPoints, hitWidth, false);
    }

    height: parent ? parent.height : 0
    width: parent ? parent.width : 0
    x: 0
    y: 0

    Repeater {
        id: vertexHandleRepeater

        readonly property var _items: Array.from({
            length: count
        }, (_, index) => itemAt(index))

        model: root.points.length

        GraphHandle {
            id: vertexGraphHandle

            required property int index

            cursorShape: Qt.PointingHandCursor
            dataTransform: root.dataTransform
            delegate: root.vertexHandleDelegate
            fillColor: root.handleFillColor
            hitSize: root.handleHitSize
            hoverFillColor: root.handleHoverFillColor
            movable: root.vertexHandlesMovable
            objectName: "point" + index
            position: root.points[index]
            role: GraphHandle.Resize
            selected: root.selected
            selectedFillColor: root.handleSelectedFillColor
            shape: root.vertexHandleShape
            size: root.handleSize
            strokeColor: root.handleStrokeColor
            strokeWidth: root.handleStrokeWidth
            visible: root.handlesVisible

            onClicked: root.handleClicked(vertexGraphHandle)
            onMoved: position => {
                root.handleMoved(vertexGraphHandle, position);
                root.pointMoved(index, position);
            }
        }
    }
    MouseArea {
        id: bodyMouseArea

        cursorShape: root.movable && (root._bodyHovered || root._bodyDragging) ? Qt.SizeAllCursor : Qt.ArrowCursor
        enabled: root.points.length > 0 && root.enabled
        height: Math.max(root._mappedBottom - root._mappedTop, root.hitWidth)
        hoverEnabled: true
        width: Math.max(root._mappedRight - root._mappedLeft, root.hitWidth)
        x: root._mappedLeft - (width - (root._mappedRight - root._mappedLeft)) / 2
        y: root._mappedTop - (height - (root._mappedBottom - root._mappedTop)) / 2

        onCanceled: {
            root._bodyDragging = false;
        }
        onExited: {
            root._bodyHovered = false;
        }
        onPositionChanged: event => {
            root._bodyHovered = root._containsBodyPoint(Qt.point(event.x, event.y));
            if (!root._bodyDragging || !root.movable)
                return;
            let currentPoint = root.dataTransform.inverted().map(root.mapFromItem(bodyMouseArea, Qt.point(event.x, event.y)));
            let delta = Qt.point(currentPoint.x - root._lastDragPoint.x, currentPoint.y - root._lastDragPoint.y);
            root._lastDragPoint = currentPoint;
            root.moved(delta);
        }
        onPressed: event => {
            if (!root._containsBodyPoint(Qt.point(event.x, event.y))) {
                root._bodyDragging = false;
                event.accepted = false;
                return;
            }
            root._bodyDragging = true;
            root.bodyClicked();
            root._lastDragPoint = root.dataTransform.inverted().map(root.mapFromItem(bodyMouseArea, Qt.point(event.x, event.y)));
        }
        onReleased: {
            root._bodyDragging = false;
        }
    }
}
