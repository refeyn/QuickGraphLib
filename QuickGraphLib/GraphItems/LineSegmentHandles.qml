// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib

/*!
    \qmltype LineSegmentHandles
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Item
    \brief Interaction overlay for a line segment region of interest.

    LineSegmentHandles provides selection, body dragging and optional handles for a line segment.
    It does not own the segment data; instead it emits movement signals so applications can update
    their own model.
*/

BaseHandles {
    id: root

    enum HandleMode {
        NoHandles,
        Endpoints,
        EndpointsAndCenter
    }

    property bool _bodyDragging: false
    readonly property point _centerPoint: Qt.point((point1.x + point2.x) / 2, (point1.y + point2.y) / 2)
    property point _lastDragPoint: Qt.point(0, 0)
    readonly property point _mappedPoint1: dataTransform.map(point1)
    readonly property point _mappedPoint2: dataTransform.map(point2)
    /*!
        A direct reference to the optional center move handle.
    */
    readonly property alias centerHandle: centerGraphHandle
    /*!
        Optional visual delegate used for the center move handle.

        The delegate can read the handle state through \c parent.handle.
    */
    property Component centerHandleDelegate: null
    /*!
        The default shape used for the center move handle.
    */
    property int centerHandleShape: GraphHandle.Square
    /*!
        The visual size and hit target size of the center handle.
    */
    property real centerHandleSize: handleSize

    /*!
        Optional visual delegate used for endpoint resize handles.

        The delegate can read the handle state through \c parent.handle.
    */
    property Component endpointHandleDelegate: null
    /*!
        The default shape used for endpoint resize handles.
    */
    property int endpointHandleShape: GraphHandle.Circle
    /*!
        Whether endpoint handles can be moved.
    */
    property bool endpointHandlesMovable: true
    /*!
        Which built-in handles should be shown.
    */
    property int handleMode: LineSegmentHandles.Endpoints
    /*!
        The visual size and hit target size of endpoint handles.
    */
    property real handleSize: 8
    /*!
        GraphHandle objects rendered by this item.
    */
    readonly property var handles: [point1GraphHandle, point2GraphHandle, centerGraphHandle]
    /*!
        The body hit target width in pixels.
    */
    property real hitWidth: 18
    /*!
        Whether dragging the segment body should emit movement signals.
    */
    property bool movable: true
    /*!
        The first endpoint in data coordinates.
    */
    required property point point1

    /*!
        A direct reference to the first endpoint resize handle.
    */
    readonly property alias point1Handle: point1GraphHandle
    /*!
        The second endpoint in data coordinates.
    */
    required property point point2
    /*!
        A direct reference to the second endpoint resize handle.
    */
    readonly property alias point2Handle: point2GraphHandle

    /*!
        Emitted when the segment body or move handle has moved by \a delta in data coordinates.
    */
    signal moved(point delta)
    /*!
        Emitted when the first endpoint has moved to \a point.
    */
    signal point1Moved(point position)
    /*!
        Emitted when the second endpoint has moved to \a point.
    */
    signal point2Moved(point position)

    function _bodyScenePoint(localPoint) {
        return root.mapFromItem(bodyMouseArea, localPoint);
    }
    function _containsBodyPoint(localPoint) {
        return _containsBodyScenePoint(_bodyScenePoint(localPoint));
    }
    function _containsBodyScenePoint(scenePoint) {
        return QuickGraphLib.Helpers.isNearSegment(scenePoint, _mappedPoint1, _mappedPoint2, hitWidth);
    }

    height: parent ? parent.height : 0
    width: parent ? parent.width : 0
    x: 0
    y: 0

    MouseArea {
        id: bodyMouseArea

        property real _segmentLeft: Math.min(root._mappedPoint1.x, root._mappedPoint2.x)
        property real _segmentTop: Math.min(root._mappedPoint1.y, root._mappedPoint2.y)

        cursorShape: root.movable && (root._bodyHovered || root._bodyDragging) ? Qt.SizeAllCursor : Qt.ArrowCursor
        enabled: root.enabled
        height: Math.max(Math.abs(root._mappedPoint2.y - root._mappedPoint1.y), root.hitWidth)
        hoverEnabled: true
        width: Math.max(Math.abs(root._mappedPoint2.x - root._mappedPoint1.x), root.hitWidth)
        x: _segmentLeft - (width - Math.abs(root._mappedPoint2.x - root._mappedPoint1.x)) / 2
        y: _segmentTop - (height - Math.abs(root._mappedPoint2.y - root._mappedPoint1.y)) / 2

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
    GraphHandle {
        id: point1GraphHandle

        cursorShape: Qt.PointingHandCursor
        dataTransform: root.dataTransform
        delegate: root.endpointHandleDelegate
        fillColor: root.handleFillColor
        hoverFillColor: root.handleHoverFillColor
        movable: root.endpointHandlesMovable
        objectName: "point1"
        position: root.point1
        role: GraphHandle.Resize
        selected: root.selected
        selectedFillColor: root.handleSelectedFillColor
        shape: root.endpointHandleShape
        size: root.handleSize
        strokeColor: root.handleStrokeColor
        strokeWidth: root.handleStrokeWidth
        visible: root.handlesVisible && root.handleMode !== LineSegmentHandles.NoHandles

        onClicked: root.handleClicked(point1GraphHandle)
        onMoved: position => {
            root.handleMoved(point1GraphHandle, position);
            root.point1Moved(position);
        }
    }
    GraphHandle {
        id: point2GraphHandle

        cursorShape: Qt.PointingHandCursor
        dataTransform: root.dataTransform
        delegate: root.endpointHandleDelegate
        fillColor: root.handleFillColor
        hoverFillColor: root.handleHoverFillColor
        movable: root.endpointHandlesMovable
        objectName: "point2"
        position: root.point2
        role: GraphHandle.Resize
        selected: root.selected
        selectedFillColor: root.handleSelectedFillColor
        shape: root.endpointHandleShape
        size: root.handleSize
        strokeColor: root.handleStrokeColor
        strokeWidth: root.handleStrokeWidth
        visible: root.handlesVisible && root.handleMode !== LineSegmentHandles.NoHandles

        onClicked: root.handleClicked(point2GraphHandle)
        onMoved: position => {
            root.handleMoved(point2GraphHandle, position);
            root.point2Moved(position);
        }
    }
    GraphHandle {
        id: centerGraphHandle

        cursorShape: Qt.SizeAllCursor
        dataTransform: root.dataTransform
        delegate: root.centerHandleDelegate
        fillColor: root.handleFillColor
        hoverFillColor: root.handleHoverFillColor
        movable: root.movable
        objectName: "center"
        position: root._centerPoint
        role: GraphHandle.Move
        selected: root.selected
        selectedFillColor: root.handleSelectedFillColor
        shape: root.centerHandleShape
        size: root.centerHandleSize
        strokeColor: root.handleStrokeColor
        strokeWidth: root.handleStrokeWidth
        visible: root.handlesVisible && root.handleMode === LineSegmentHandles.EndpointsAndCenter

        onClicked: root.handleClicked(centerGraphHandle)
        onMoved: position => {
            root.handleMoved(centerGraphHandle, position);
            root.moved(Qt.point(position.x - centerGraphHandle.position.x, position.y - centerGraphHandle.position.y));
        }
    }
}
