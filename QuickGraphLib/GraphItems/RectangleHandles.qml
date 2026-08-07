// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib

/*!
    \qmltype RectangleHandles
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Item
    \brief Interaction overlay for a rectangular region of interest.

    RectangleHandles provides selection, body dragging and optional corner handles for a rectangle.
    It does not own the rectangle data; instead it emits movement and resize signals so
    applications can update their own model.
*/

BaseHandles {
    id: root

    enum HandleMode {
        NoHandles,
        Corners,
        CornersAndCenter
    }

    readonly property point _bottomLeftPoint: Qt.point(_dataLeft, _dataBottom)
    readonly property point _bottomRightPoint: Qt.point(_dataRight, _dataBottom)
    readonly property point _centerPoint: Qt.point((_dataLeft + _dataRight) / 2, (_dataTop + _dataBottom) / 2)
    readonly property real _dataBottom: _normalizedDataRect.bottom
    readonly property real _dataLeft: _normalizedDataRect.left
    readonly property real _dataRight: _normalizedDataRect.right
    readonly property real _dataTop: _normalizedDataRect.top
    property point _lastDragPoint: Qt.point(0, 0)
    readonly property point _mappedBottomLeft: dataTransform.map(_bottomLeftPoint)
    readonly property point _mappedBottomRight: dataTransform.map(_bottomRightPoint)
    readonly property rect _mappedRect: dataTransform.mapRect(_normalizedDataRect)
    readonly property point _mappedTopLeft: dataTransform.map(_topLeftPoint)
    readonly property point _mappedTopRight: dataTransform.map(_topRightPoint)
    readonly property rect _normalizedDataRect: QuickGraphLib.Helpers.normalizedRect(dataRect)
    readonly property point _topLeftPoint: Qt.point(_dataLeft, _dataTop)
    readonly property point _topRightPoint: Qt.point(_dataRight, _dataTop)
    /*!
        A direct reference to the bottom-left corner resize handle.
    */
    readonly property alias bottomLeftHandle: bottomLeftGraphHandle
    /*!
        A direct reference to the bottom-right corner resize handle.
    */
    readonly property alias bottomRightHandle: bottomRightGraphHandle
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
    property int centerHandleShape: GraphHandle.Circle
    /*!
        The visual size and hit target size of the center handle.
    */
    property real centerHandleSize: handleSize
    /*!
        Optional visual delegate used for corner resize handles.

        The delegate can read the handle state through \c parent.handle.
    */
    property Component cornerHandleDelegate: null
    /*!
        The default shape used for corner resize handles.
    */
    property int cornerHandleShape: GraphHandle.Square
    /*!
        Whether corner handles can resize the rectangle.
    */
    property bool cornerHandlesMovable: true
    /*!
        The rectangle in data coordinates.
    */
    required property rect dataRect

    /*!
        Which handles should be shown.
    */
    property int handleMode: RectangleHandles.Corners
    /*!
        The visual size and hit target size of corner handles.
    */
    property real handleSize: 8
    /*!
        GraphHandle objects rendered by this item.
    */
    readonly property var handles: [topLeftGraphHandle, topRightGraphHandle, bottomLeftGraphHandle, bottomRightGraphHandle, centerGraphHandle]
    /*!
        The minimum height emitted when resize handles are dragged toward the opposite anchor.
    */
    property real minimumDataHeight: 0
    /*!
        The minimum width emitted when resize handles are dragged toward the opposite anchor.
    */
    property real minimumDataWidth: 0
    /*!
        Whether dragging the rectangle body should emit movement signals.
    */
    property bool movable: true
    /*!
        A direct reference to the top-left corner resize handle.
    */
    readonly property alias topLeftHandle: topLeftGraphHandle
    /*!
        A direct reference to the top-right corner resize handle.
    */
    readonly property alias topRightHandle: topRightGraphHandle

    /*!
        Emitted when the rectangle body has moved by \a delta in data coordinates.
    */
    signal moved(point delta)
    /*!
        Emitted when a corner handle has resized the rectangle to \a dataRect.
    */
    signal resized(rect dataRect)

    function _bodyScenePoint(localPoint) {
        return root.mapFromItem(bodyMouseArea, localPoint);
    }
    function _containsBodyPoint(localPoint) {
        return _containsBodyScenePoint(_bodyScenePoint(localPoint));
    }
    function _containsBodyScenePoint(scenePoint) {
        return QuickGraphLib.Helpers.isInsidePolygon(scenePoint, [_mappedTopLeft, _mappedTopRight, _mappedBottomRight, _mappedBottomLeft]);
    }
    function _resizedFromHandle(handle, position) {
        if (handle.objectName === "topLeft") {
            return QuickGraphLib.Helpers.clampedResizeRect(position, root._bottomRightPoint, root.minimumDataWidth, root.minimumDataHeight, -1, -1);
        }
        if (handle.objectName === "topRight") {
            return QuickGraphLib.Helpers.clampedResizeRect(position, root._bottomLeftPoint, root.minimumDataWidth, root.minimumDataHeight, 1, -1);
        }
        if (handle.objectName === "bottomLeft") {
            return QuickGraphLib.Helpers.clampedResizeRect(position, root._topRightPoint, root.minimumDataWidth, root.minimumDataHeight, -1, 1);
        }
        if (handle.objectName === "bottomRight") {
            return QuickGraphLib.Helpers.clampedResizeRect(position, root._topLeftPoint, root.minimumDataWidth, root.minimumDataHeight, 1, 1);
        }
        return root.dataRect;
    }

    height: parent ? parent.height : 0
    width: parent ? parent.width : 0
    x: 0
    y: 0

    MouseArea {
        id: bodyMouseArea

        cursorShape: root.movable ? Qt.SizeAllCursor : Qt.ArrowCursor
        enabled: root.enabled
        height: root._mappedRect.height
        hoverEnabled: true
        width: root._mappedRect.width
        x: root._mappedRect.x
        y: root._mappedRect.y

        onExited: root._bodyHovered = false
        onPositionChanged: event => {
            root._bodyHovered = root._containsBodyPoint(Qt.point(event.x, event.y));
            if (!pressed || !root.movable)
                return;
            let currentPoint = root.dataTransform.inverted().map(root.mapFromItem(bodyMouseArea, Qt.point(event.x, event.y)));
            let delta = Qt.point(currentPoint.x - root._lastDragPoint.x, currentPoint.y - root._lastDragPoint.y);
            root._lastDragPoint = currentPoint;
            root.moved(delta);
        }
        onPressed: event => {
            root.bodyClicked();
            root._lastDragPoint = root.dataTransform.inverted().map(root.mapFromItem(bodyMouseArea, Qt.point(event.x, event.y)));
        }
    }
    GraphHandle {
        id: topLeftGraphHandle

        cursorShape: Qt.SizeBDiagCursor
        dataTransform: root.dataTransform
        delegate: root.cornerHandleDelegate
        fillColor: root.handleFillColor
        hoverFillColor: root.handleHoverFillColor
        movable: root.cornerHandlesMovable
        objectName: "topLeft"
        position: root._topLeftPoint
        role: GraphHandle.Resize
        selected: root.selected
        selectedFillColor: root.handleSelectedFillColor
        shape: root.cornerHandleShape
        size: root.handleSize
        strokeColor: root.handleStrokeColor
        strokeWidth: root.handleStrokeWidth
        visible: root.handlesVisible && root.handleMode !== RectangleHandles.NoHandles

        onClicked: root.handleClicked(topLeftGraphHandle)
        onMoved: position => {
            root.handleMoved(topLeftGraphHandle, position);
            root.resized(root._resizedFromHandle(topLeftGraphHandle, position));
        }
    }
    GraphHandle {
        id: topRightGraphHandle

        cursorShape: Qt.SizeFDiagCursor
        dataTransform: root.dataTransform
        delegate: root.cornerHandleDelegate
        fillColor: root.handleFillColor
        hoverFillColor: root.handleHoverFillColor
        movable: root.cornerHandlesMovable
        objectName: "topRight"
        position: root._topRightPoint
        role: GraphHandle.Resize
        selected: root.selected
        selectedFillColor: root.handleSelectedFillColor
        shape: root.cornerHandleShape
        size: root.handleSize
        strokeColor: root.handleStrokeColor
        strokeWidth: root.handleStrokeWidth
        visible: root.handlesVisible && root.handleMode !== RectangleHandles.NoHandles

        onClicked: root.handleClicked(topRightGraphHandle)
        onMoved: position => {
            root.handleMoved(topRightGraphHandle, position);
            root.resized(root._resizedFromHandle(topRightGraphHandle, position));
        }
    }
    GraphHandle {
        id: bottomLeftGraphHandle

        cursorShape: Qt.SizeFDiagCursor
        dataTransform: root.dataTransform
        delegate: root.cornerHandleDelegate
        fillColor: root.handleFillColor
        hoverFillColor: root.handleHoverFillColor
        movable: root.cornerHandlesMovable
        objectName: "bottomLeft"
        position: root._bottomLeftPoint
        role: GraphHandle.Resize
        selected: root.selected
        selectedFillColor: root.handleSelectedFillColor
        shape: root.cornerHandleShape
        size: root.handleSize
        strokeColor: root.handleStrokeColor
        strokeWidth: root.handleStrokeWidth
        visible: root.handlesVisible && root.handleMode !== RectangleHandles.NoHandles

        onClicked: root.handleClicked(bottomLeftGraphHandle)
        onMoved: position => {
            root.handleMoved(bottomLeftGraphHandle, position);
            root.resized(root._resizedFromHandle(bottomLeftGraphHandle, position));
        }
    }
    GraphHandle {
        id: bottomRightGraphHandle

        cursorShape: Qt.SizeBDiagCursor
        dataTransform: root.dataTransform
        delegate: root.cornerHandleDelegate
        fillColor: root.handleFillColor
        hoverFillColor: root.handleHoverFillColor
        movable: root.cornerHandlesMovable
        objectName: "bottomRight"
        position: root._bottomRightPoint
        role: GraphHandle.Resize
        selected: root.selected
        selectedFillColor: root.handleSelectedFillColor
        shape: root.cornerHandleShape
        size: root.handleSize
        strokeColor: root.handleStrokeColor
        strokeWidth: root.handleStrokeWidth
        visible: root.handlesVisible && root.handleMode !== RectangleHandles.NoHandles

        onClicked: root.handleClicked(bottomRightGraphHandle)
        onMoved: position => {
            root.handleMoved(bottomRightGraphHandle, position);
            root.resized(root._resizedFromHandle(bottomRightGraphHandle, position));
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
        visible: root.handlesVisible && root.handleMode === RectangleHandles.CornersAndCenter

        onClicked: root.handleClicked(centerGraphHandle)
        onMoved: position => {
            root.handleMoved(centerGraphHandle, position);
            root.moved(Qt.point(position.x - centerGraphHandle.position.x, position.y - centerGraphHandle.position.y));
        }
    }
}
