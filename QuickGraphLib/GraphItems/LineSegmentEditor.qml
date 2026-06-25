// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype LineSegmentEditor
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Item
    \brief Interaction overlay for editing a LineSegment.

    LineSegmentEditor provides selection, body dragging and optional handles for a line segment.
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

    readonly property point centerPoint: Qt.point((point1.x + point2.x) / 2, (point1.y + point2.y) / 2)
    readonly property point mappedCenterPoint: dataTransform.map(centerPoint)
    readonly property point mappedPoint1: dataTransform.map(point1)
    readonly property point mappedPoint2: dataTransform.map(point2)

    /*!
        Must be assigned the data transform of the graph area this editor is paired to.

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
        Whether the editor should be drawn in the selected state.
    */
    property bool selected: false
    /*!
        Whether handles should be visible.
    */
    property bool handlesVisible: selected
    /*!
        Which handles should be shown.
    */
    property int handleMode: LineSegmentEditor.Endpoints
    /*!
        The body hit target width in pixels.
    */
    property real hitWidth: 18
    /*!
        The visual size and hit target size of endpoint handles.
    */
    property real handleSize: 12
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
        Emitted when the editor requests selection.
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
        Emitted when the segment body has moved by \a delta in data coordinates.
    */
    signal moved(point delta)

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
        cursorShape: root.movable ? Qt.SizeAllCursor : Qt.ArrowCursor
        width: Math.max(Math.abs(root.mappedPoint2.x - root.mappedPoint1.x), root.hitWidth)
        x: segmentLeft - (width - Math.abs(root.mappedPoint2.x - root.mappedPoint1.x)) / 2
        y: segmentTop - (height - Math.abs(root.mappedPoint2.y - root.mappedPoint1.y)) / 2

        onPressed: event => {
            if (root.selectable) root.selectionRequested();
            root._lastDragPoint = root.dataTransform.inverted().map(Qt.point(bodyMouseArea.x + event.x, bodyMouseArea.y + event.y));
        }
        onPositionChanged: event => {
            if (!pressed || !root.movable) return;
            let currentPoint = root.dataTransform.inverted().map(Qt.point(bodyMouseArea.x + event.x, bodyMouseArea.y + event.y));
            let delta = Qt.point(currentPoint.x - root._lastDragPoint.x, currentPoint.y - root._lastDragPoint.y);
            root._lastDragPoint = currentPoint;
            root.moved(delta);
        }
    }
    GraphHandle {
        dataTransform: root.dataTransform
        delegate: root.endpointHandleDelegate
        fillColor: root.handleFillColor
        hoverFillColor: root.handleHoverFillColor
        movable: root.endpointHandlesMovable
        position: root.point1
        role: GraphHandle.Resize
        selectable: root.selectable
        selected: root.selected
        selectedFillColor: root.handleSelectedFillColor
        shape: root.endpointHandleShape
        size: root.handleSize
        strokeColor: root.handleStrokeColor
        strokeWidth: root.handleStrokeWidth
        visible: root.handlesVisible && root.handleMode !== LineSegmentEditor.NoHandles

        onMoved: point => root.point1Moved(point)
        onSelectionRequested: root.selectionRequested()
    }
    GraphHandle {
        dataTransform: root.dataTransform
        delegate: root.endpointHandleDelegate
        fillColor: root.handleFillColor
        hoverFillColor: root.handleHoverFillColor
        movable: root.endpointHandlesMovable
        position: root.point2
        role: GraphHandle.Resize
        selectable: root.selectable
        selected: root.selected
        selectedFillColor: root.handleSelectedFillColor
        shape: root.endpointHandleShape
        size: root.handleSize
        strokeColor: root.handleStrokeColor
        strokeWidth: root.handleStrokeWidth
        visible: root.handlesVisible && root.handleMode !== LineSegmentEditor.NoHandles

        onMoved: point => root.point2Moved(point)
        onSelectionRequested: root.selectionRequested()
    }
    GraphHandle {
        dataTransform: root.dataTransform
        delegate: root.centerHandleDelegate
        fillColor: root.handleFillColor
        hoverFillColor: root.handleHoverFillColor
        movable: root.movable
        position: root.centerPoint
        role: GraphHandle.Move
        selectable: root.selectable
        selected: root.selected
        selectedFillColor: root.handleSelectedFillColor
        shape: root.centerHandleShape
        size: root.centerHandleSize
        strokeColor: root.handleStrokeColor
        strokeWidth: root.handleStrokeWidth
        visible: root.handlesVisible && root.handleMode === LineSegmentEditor.EndpointsAndCenter

        onMoved: point => root.moved(Qt.point(point.x - root.centerPoint.x, point.y - root.centerPoint.y))
        onSelectionRequested: root.selectionRequested()
    }
}
