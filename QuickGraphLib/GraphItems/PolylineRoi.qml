// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import "RoiHitTest.js" as RoiHitTest

/*!
    \qmltype PolylineRoi
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Item
    \brief Interaction overlay for an open polyline region of interest.

    PolylineRoi provides selection, body dragging and vertex handles for a list of points. It does
    not own the point data; instead it emits movement signals so applications can update their own
    model.
*/

Item {
    id: root

    property bool _bodyDragging: false
    property bool _bodyHovered: false
    property point _lastDragPoint: Qt.point(0, 0)
    /*!
        Whether this ROI should rebuild \l handles from \l points automatically.

        Set this to false before assigning a custom handle list.
    */
    property bool autoHandles: true

    /*!
        Must be assigned the data transform of the graph area this ROI is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        The normal handle fill color.
    */
    property color handleFillColor: "white"
    /*!
        The mouse hit target size of vertex handles.
    */
    property real handleHitSize: 24
    /*!
        The handle fill color used while hovered.
    */
    property color handleHoverFillColor: "#fff6bf"
    /*!
        The handle fill color used while selected or dragged.
    */
    property color handleSelectedFillColor: "#ffd24d"
    /*!
        The visual size and hit target size of vertex handles.
    */
    property real handleSize: 8
    /*!
        The handle outline color.
    */
    property color handleStrokeColor: "#333333"
    /*!
        The handle outline width.
    */
    property real handleStrokeWidth: 1
    /*!
        Handle configuration objects rendered by this ROI.
    */
    property var handles: []
    /*!
        Whether vertex handles should be visible.
    */
    property bool handlesVisible: selected
    /*!
        The body hit target width in pixels.
    */
    property real hitWidth: 18
    readonly property real mappedBottom: mappedPoints.length === 0 ? 0 : Math.max(...mappedPoints.map(point => point.y))
    readonly property real mappedLeft: mappedPoints.length === 0 ? 0 : Math.min(...mappedPoints.map(point => point.x))
    readonly property var mappedPoints: points.map(point => dataTransform.map(point))
    readonly property real mappedRight: mappedPoints.length === 0 ? 0 : Math.max(...mappedPoints.map(point => point.x))
    readonly property real mappedTop: mappedPoints.length === 0 ? 0 : Math.min(...mappedPoints.map(point => point.y))
    /*!
        Whether dragging the polyline body should emit movement signals.
    */
    property bool movable: true
    /*!
        Points in data coordinates.
    */
    required property var points
    /*!
        Whether pressing the polyline or handles should emit \l selectionRequested.
    */
    property bool selectable: true
    /*!
        Whether the ROI should be drawn in the selected state.
    */
    property bool selected: false
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
        Emitted when \a handle has moved to \a position in data coordinates.
    */
    signal handleMoved(RoiHandle handle, point position)
    /*!
        Emitted when the polyline body has moved by \a delta in data coordinates.
    */
    signal moved(point delta)
    /*!
        Emitted when point \a index has moved to \a position in data coordinates.
    */
    signal pointMoved(int index, point position)

    /*!
        Emitted when the ROI requests selection.
    */
    signal selectionRequested

    function bodyScenePoint(localPoint) {
        return Qt.point(bodyMouseArea.x + localPoint.x, bodyMouseArea.y + localPoint.y);
    }
    function configureHandle(handle, index) {
        handle.cursorShape = Qt.PointingHandCursor;
        handle.delegate = root.vertexHandleDelegate;
        handle.hitSize = root.handleHitSize;
        handle.movable = root.vertexHandlesMovable;
        handle.name = "point" + index;
        handle.position = root.points[index];
        handle.role = GraphHandle.Resize;
        handle.shape = root.vertexHandleShape;
        handle.size = root.handleSize;
        handle.visible = root.handlesVisible;
    }
    function containsBodyPoint(localPoint) {
        return containsBodyScenePoint(bodyScenePoint(localPoint));
    }
    function containsBodyScenePoint(scenePoint) {
        return RoiHitTest.isNearPolyline(scenePoint, mappedPoints, hitWidth, false);
    }
    function handleIndex(handle) {
        return parseInt(handle.name.slice(5));
    }
    function rebuildHandles() {
        if (!autoHandles)
            return;

        let oldHandles = handles;
        handles = [];
        for (let oldIndex = 0; oldIndex < oldHandles.length; oldIndex++) {
            oldHandles[oldIndex].destroy();
        }

        let nextHandles = [];
        for (let index = 0; index < points.length; index++) {
            let handle = vertexHandleComponent.createObject(root);
            configureHandle(handle, index);
            nextHandles.push(handle);
        }
        handles = nextHandles;
    }
    function updateHandles() {
        if (!autoHandles)
            return;

        if (handles.length !== points.length) {
            rebuildHandles();
            return;
        }

        for (let index = 0; index < handles.length; index++) {
            configureHandle(handles[index], index);
        }
    }

    height: parent ? parent.height : 0
    width: parent ? parent.width : 0
    x: 0
    y: 0

    Component.onCompleted: rebuildHandles()
    onHandleHitSizeChanged: updateHandles()
    onHandleSizeChanged: updateHandles()
    onHandlesVisibleChanged: updateHandles()
    onPointsChanged: updateHandles()
    onVertexHandleDelegateChanged: updateHandles()
    onVertexHandleShapeChanged: updateHandles()
    onVertexHandlesMovableChanged: updateHandles()

    Component {
        id: vertexHandleComponent

        RoiHandle {
        }
    }
    MouseArea {
        id: bodyMouseArea

        cursorShape: root.movable && (root._bodyHovered || root._bodyDragging) ? Qt.SizeAllCursor : Qt.ArrowCursor
        enabled: root.points.length > 0 && (root.selectable || root.movable)
        height: Math.max(root.mappedBottom - root.mappedTop, root.hitWidth)
        hoverEnabled: true
        width: Math.max(root.mappedRight - root.mappedLeft, root.hitWidth)
        x: root.mappedLeft - (width - (root.mappedRight - root.mappedLeft)) / 2
        y: root.mappedTop - (height - (root.mappedBottom - root.mappedTop)) / 2

        onCanceled: {
            root._bodyDragging = false;
        }
        onExited: {
            root._bodyHovered = false;
        }
        onPositionChanged: event => {
            root._bodyHovered = root.containsBodyPoint(Qt.point(event.x, event.y));
            if (!root._bodyDragging || !root.movable)
                return;
            let currentPoint = root.dataTransform.inverted().map(Qt.point(bodyMouseArea.x + event.x, bodyMouseArea.y + event.y));
            let delta = Qt.point(currentPoint.x - root._lastDragPoint.x, currentPoint.y - root._lastDragPoint.y);
            root._lastDragPoint = currentPoint;
            root.moved(delta);
        }
        onPressed: event => {
            if (!root.containsBodyPoint(Qt.point(event.x, event.y))) {
                root._bodyDragging = false;
                event.accepted = false;
                return;
            }
            root._bodyDragging = true;
            if (root.selectable)
                root.selectionRequested();
            root._lastDragPoint = root.dataTransform.inverted().map(Qt.point(bodyMouseArea.x + event.x, bodyMouseArea.y + event.y));
        }
        onReleased: {
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
            let index = root.handleIndex(handle);
            root.handleMoved(handle, position);
            root.pointMoved(index, position);
        }
        onHandleSelectionRequested: handle => root.selectionRequested()
    }
}
