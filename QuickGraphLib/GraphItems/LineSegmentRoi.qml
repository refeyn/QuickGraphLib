// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import "RoiHitTest.js" as RoiHitTest

/*!
    \qmltype LineSegmentRoi
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Item
    \brief Interaction overlay for a line segment region of interest.

    LineSegmentRoi provides selection, body dragging and optional handles for a line segment.
    It does not own the segment data; instead it emits movement signals so applications can update
    their own model.
*/

Item {
    id: root

    enum HandleMode {
        NoHandles,
        Endpoints,
        EndpointsAndCenter
    }

    property point _lastDragPoint: Qt.point(0, 0)
    property bool _bodyDragging: false
    property bool _bodyHovered: false

    readonly property point centerPoint: Qt.point((point1.x + point2.x) / 2, (point1.y + point2.y) / 2)
    readonly property point mappedPoint1: dataTransform.map(point1)
    readonly property point mappedPoint2: dataTransform.map(point2)

    /*!
        A direct reference to the first endpoint resize handle.
    */
    readonly property RoiHandle point1Handle: point1HandleSpec
    /*!
        A direct reference to the second endpoint resize handle.
    */
    readonly property RoiHandle point2Handle: point2HandleSpec
    /*!
        A direct reference to the optional center move handle.
    */
    readonly property RoiHandle centerHandle: centerHandleSpec

    /*!
        Must be assigned the data transform of the graph area this ROI is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        The first endpoint in data coordinates.
    */
    required property point point1
    /*!
        The second endpoint in data coordinates.
    */
    required property point point2
    /*!
        Whether pressing the segment or handles should emit \l selectionRequested.
    */
    property bool selectable: true
    /*!
        Whether dragging the segment body should emit movement signals.
    */
    property bool movable: true
    /*!
        Whether endpoint handles can be moved.
    */
    property bool endpointHandlesMovable: true
    /*!
        Whether the ROI should be drawn in the selected state.
    */
    property bool selected: false
    /*!
        Whether handles should be visible.
    */
    property bool handlesVisible: selected
    /*!
        Which built-in handles should be shown.
    */
    property int handleMode: LineSegmentRoi.Endpoints
    /*!
        Handle configuration objects rendered by this ROI.
    */
    property list<RoiHandle> handles: [
        RoiHandle {
            id: point1HandleSpec

            cursorShape: Qt.PointingHandCursor
            movable: root.endpointHandlesMovable
            name: "point1"
            position: root.point1
            role: GraphHandle.Resize
            shape: root.endpointHandleShape
            size: root.handleSize
            delegate: root.endpointHandleDelegate
            visible: root.handlesVisible && root.handleMode !== LineSegmentRoi.NoHandles
        },
        RoiHandle {
            id: point2HandleSpec

            cursorShape: Qt.PointingHandCursor
            movable: root.endpointHandlesMovable
            name: "point2"
            position: root.point2
            role: GraphHandle.Resize
            shape: root.endpointHandleShape
            size: root.handleSize
            delegate: root.endpointHandleDelegate
            visible: root.handlesVisible && root.handleMode !== LineSegmentRoi.NoHandles
        },
        RoiHandle {
            id: centerHandleSpec

            cursorShape: Qt.SizeAllCursor
            movable: root.movable
            name: "center"
            position: root.centerPoint
            role: GraphHandle.Move
            shape: root.centerHandleShape
            size: root.centerHandleSize
            delegate: root.centerHandleDelegate
            visible: root.handlesVisible && root.handleMode === LineSegmentRoi.EndpointsAndCenter
        }
    ]
    /*!
        The body hit target width in pixels.
    */
    property real hitWidth: 18
    /*!
        The visual size and hit target size of endpoint handles.
    */
    property real handleSize: 8
    /*!
        The visual size and hit target size of the center handle.
    */
    property real centerHandleSize: handleSize
    /*!
        The default shape used for endpoint resize handles.
    */
    property int endpointHandleShape: GraphHandle.Circle
    /*!
        The default shape used for the center move handle.
    */
    property int centerHandleShape: GraphHandle.Square
    /*!
        Optional visual delegate used for endpoint resize handles.

        The delegate can read the handle state through \c parent.handle.
    */
    property Component endpointHandleDelegate: null
    /*!
        Optional visual delegate used for the center move handle.

        The delegate can read the handle state through \c parent.handle.
    */
    property Component centerHandleDelegate: null
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
        Emitted when the ROI requests selection.
    */
    signal selectionRequested()
    /*!
        Emitted when the first endpoint has moved to \a point.
    */
    signal point1Moved(point position)
    /*!
        Emitted when the second endpoint has moved to \a point.
    */
    signal point2Moved(point position)
    /*!
        Emitted when the segment body or move handle has moved by \a delta in data coordinates.
    */
    signal moved(point delta)
    /*!
        Emitted when \a handle has moved to \a position in data coordinates.
    */
    signal handleMoved(RoiHandle handle, point position)

    function bodyScenePoint(localPoint) {
        return Qt.point(bodyMouseArea.x + localPoint.x, bodyMouseArea.y + localPoint.y);
    }

    function containsBodyScenePoint(scenePoint) {
        return RoiHitTest.isNearSegment(scenePoint, mappedPoint1, mappedPoint2, hitWidth);
    }

    function containsBodyPoint(localPoint) {
        return containsBodyScenePoint(bodyScenePoint(localPoint));
    }

    x: 0
    y: 0
    width: parent ? parent.width : 0
    height: parent ? parent.height : 0

    MouseArea {
        id: bodyMouseArea

        property real segmentLeft: Math.min(root.mappedPoint1.x, root.mappedPoint2.x)
        property real segmentTop: Math.min(root.mappedPoint1.y, root.mappedPoint2.y)

        enabled: root.selectable || root.movable
        height: Math.max(Math.abs(root.mappedPoint2.y - root.mappedPoint1.y), root.hitWidth)
        hoverEnabled: true
        cursorShape: root.movable && (root._bodyHovered || root._bodyDragging) ? Qt.SizeAllCursor : Qt.ArrowCursor
        width: Math.max(Math.abs(root.mappedPoint2.x - root.mappedPoint1.x), root.hitWidth)
        x: segmentLeft - (width - Math.abs(root.mappedPoint2.x - root.mappedPoint1.x)) / 2
        y: segmentTop - (height - Math.abs(root.mappedPoint2.y - root.mappedPoint1.y)) / 2

        onPressed: event => {
            if (!root.containsBodyPoint(Qt.point(event.x, event.y))) {
                root._bodyDragging = false;
                event.accepted = false;
                return;
            }
            root._bodyDragging = true;
            if (root.selectable) root.selectionRequested();
            root._lastDragPoint = root.dataTransform.inverted().map(Qt.point(bodyMouseArea.x + event.x, bodyMouseArea.y + event.y));
        }
        onPositionChanged: event => {
            root._bodyHovered = root.containsBodyPoint(Qt.point(event.x, event.y));
            if (!root._bodyDragging || !root.movable) return;
            let currentPoint = root.dataTransform.inverted().map(Qt.point(bodyMouseArea.x + event.x, bodyMouseArea.y + event.y));
            let delta = Qt.point(currentPoint.x - root._lastDragPoint.x, currentPoint.y - root._lastDragPoint.y);
            root._lastDragPoint = currentPoint;
            root.moved(delta);
        }
        onExited: {
            root._bodyHovered = false;
        }
        onReleased: {
            root._bodyDragging = false;
        }
        onCanceled: {
            root._bodyDragging = false;
        }
    }
    RoiHandleRepeater {
        dataTransform: root.dataTransform
        fillColor: root.handleFillColor
        handles: root.handles
        hoverFillColor: root.handleHoverFillColor
        selectable: root.selectable
        selected: root.selected
        selectedFillColor: root.handleSelectedFillColor
        strokeColor: root.handleStrokeColor
        strokeWidth: root.handleStrokeWidth

        onHandleMoved: (handle, position) => {
            root.handleMoved(handle, position);
            if (handle.name === "point1") {
                root.point1Moved(position);
            } else if (handle.name === "point2") {
                root.point2Moved(position);
            } else if (handle.role === GraphHandle.Move) {
                root.moved(Qt.point(position.x - handle.position.x, position.y - handle.position.y));
            }
        }
        onHandleSelectionRequested: handle => root.selectionRequested()
    }
}
