// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype PolygonRoi
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Item
    \brief Interaction overlay for a polygon region of interest.

    PolygonRoi provides selection, body dragging and vertex handles for a closed list of points. It
    does not own the point data; instead it emits movement signals so applications can update their
    own model.
*/

Item {
    id: root

    property point _lastDragPoint: Qt.point(0, 0)

    readonly property var mappedPoints: points.map(point => dataTransform.map(point))
    readonly property real mappedBottom: mappedPoints.length === 0 ? 0 : Math.max(...mappedPoints.map(point => point.y))
    readonly property real mappedLeft: mappedPoints.length === 0 ? 0 : Math.min(...mappedPoints.map(point => point.x))
    readonly property real mappedRight: mappedPoints.length === 0 ? 0 : Math.max(...mappedPoints.map(point => point.x))
    readonly property real mappedTop: mappedPoints.length === 0 ? 0 : Math.min(...mappedPoints.map(point => point.y))

    /*!
        Must be assigned the data transform of the graph area this ROI is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        Polygon vertices in data coordinates.
    */
    required property var points
    /*!
        Whether pressing the polygon or handles should emit \l selectionRequested.
    */
    property bool selectable: true
    /*!
        Whether dragging the polygon body should emit movement signals.
    */
    property bool movable: true
    /*!
        Whether vertex handles can move individual points.
    */
    property bool vertexHandlesMovable: true
    /*!
        Whether the ROI should be drawn in the selected state.
    */
    property bool selected: false
    /*!
        Whether vertex handles should be visible.
    */
    property bool handlesVisible: selected
    /*!
        Handle configuration objects rendered by this ROI.
    */
    property var handles: []
    /*!
        Whether this ROI should rebuild \l handles from \l points automatically.

        Set this to false before assigning a custom handle list.
    */
    property bool autoHandles: true
    /*!
        The body hit target padding in pixels.
    */
    property real hitPadding: 8
    /*!
        The visual size of vertex handles.
    */
    property real handleSize: 12
    /*!
        The mouse hit target size of vertex handles.
    */
    property real handleHitSize: 24
    /*!
        The default shape used for vertex resize handles.
    */
    property int vertexHandleShape: GraphHandle.Circle
    /*!
        Optional visual delegate used for vertex handles.

        The delegate can read the handle state through \c parent.handle.
    */
    property Component vertexHandleDelegate: null
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
        Emitted when the polygon body has moved by \a delta in data coordinates.
    */
    signal moved(point delta)
    /*!
        Emitted when point \a index has moved to \a position in data coordinates.
    */
    signal pointMoved(int index, point position)
    /*!
        Emitted when \a handle has moved to \a position in data coordinates.
    */
    signal handleMoved(RoiHandle handle, point position)

    function configureHandle(handle, index) {
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

    function rebuildHandles() {
        if (!autoHandles) return;

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
        if (!autoHandles) return;

        if (handles.length !== points.length) {
            rebuildHandles();
            return;
        }

        for (let index = 0; index < handles.length; index++) {
            configureHandle(handles[index], index);
        }
    }

    function handleIndex(handle) {
        return parseInt(handle.name.slice(5));
    }

    onHandleSizeChanged: updateHandles()
    onHandleHitSizeChanged: updateHandles()
    onHandlesVisibleChanged: updateHandles()
    onPointsChanged: updateHandles()
    onVertexHandleDelegateChanged: updateHandles()
    onVertexHandleShapeChanged: updateHandles()
    onVertexHandlesMovableChanged: updateHandles()

    Component.onCompleted: rebuildHandles()

    Component {
        id: vertexHandleComponent

        RoiHandle {}
    }

    x: 0
    y: 0
    width: parent ? parent.width : 0
    height: parent ? parent.height : 0

    MouseArea {
        id: bodyMouseArea

        enabled: root.points.length > 0 && (root.selectable || root.movable)
        height: Math.max(root.mappedBottom - root.mappedTop + root.hitPadding * 2, root.hitPadding * 2)
        hoverEnabled: true
        cursorShape: root.movable ? Qt.SizeAllCursor : Qt.ArrowCursor
        width: Math.max(root.mappedRight - root.mappedLeft + root.hitPadding * 2, root.hitPadding * 2)
        x: root.mappedLeft - root.hitPadding
        y: root.mappedTop - root.hitPadding

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
