// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib

/*!
    \qmltype PolygonHandles
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Item
    \brief Interaction overlay for a polygon region of interest.

    PolygonHandles provides selection, body dragging and vertex handles for a closed list of points. It
    does not own the point data; instead it emits movement signals so applications can update their
    own model.
*/

BaseHandles {
    id: root

    property bool _bodyDragging: false
    property point _lastDragPoint: Qt.point(0, 0)
    readonly property real _mappedBottom: _mappedRect.bottom
    readonly property real _mappedLeft: _mappedRect.left
    readonly property var _mappedPoints: QuickGraphLib.Helpers.mapPoints(points, root.dataTransform)
    readonly property rect _mappedRect: QuickGraphLib.Helpers.boundingRect(_mappedPoints)
    readonly property real _mappedRight: _mappedRect.right
    readonly property real _mappedTop: _mappedRect.top
    /*!
        The mouse hit target size of vertex handles.
    */
    property real handleHitSize: 24
    /*!
        The visual size of vertex handles.
    */
    property real handleSize: 8
    /*!
        GraphHandle objects rendered by this item.
    */
    readonly property var handles: vertexHandleRepeater._items
    /*!
        The body hit target padding in pixels.
    */
    property real hitPadding: 8
    /*!
        Whether dragging the polygon body should emit movement signals.
    */
    property bool movable: true
    /*!
        Polygon vertices in data coordinates.
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
        Emitted when the polygon body has moved by \a delta in data coordinates.
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
        return QuickGraphLib.Helpers.isInsidePolygon(scenePoint, _mappedPoints) || QuickGraphLib.Helpers.isNearPolyline(scenePoint, _mappedPoints, hitPadding * 2, true);
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
        height: Math.max(root._mappedBottom - root._mappedTop + root.hitPadding * 2, root.hitPadding * 2)
        hoverEnabled: true
        width: Math.max(root._mappedRight - root._mappedLeft + root.hitPadding * 2, root.hitPadding * 2)
        x: root._mappedLeft - root.hitPadding
        y: root._mappedTop - root.hitPadding

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
