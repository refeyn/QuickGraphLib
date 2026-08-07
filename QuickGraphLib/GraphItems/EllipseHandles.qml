// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib

/*!
    \qmltype EllipseHandles
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Item
    \brief Interaction overlay for an elliptical region of interest.

    EllipseHandles provides selection, body dragging and optional cardinal resize handles for an
    ellipse. It does not own the ellipse data; instead it emits movement and resize signals so
    applications can update their own model.
*/

BaseHandles {
    id: root

    enum HandleMode {
        NoHandles,
        Cardinal,
        CardinalAndCenter
    }

    property bool _bodyDragging: false
    readonly property point _bottomHandlePoint: Qt.point(_centerPoint.x, _dataBottom)
    readonly property point _centerPoint: Qt.point((_dataLeft + _dataRight) / 2, (_dataTop + _dataBottom) / 2)
    readonly property real _dataBottom: Math.max(dataRect.y, dataRect.y + dataRect.height)
    readonly property real _dataLeft: Math.min(dataRect.x, dataRect.x + dataRect.width)
    readonly property real _dataRight: Math.max(dataRect.x, dataRect.x + dataRect.width)
    readonly property real _dataTop: Math.min(dataRect.y, dataRect.y + dataRect.height)
    property point _lastDragPoint: Qt.point(0, 0)
    readonly property point _leftHandlePoint: Qt.point(_dataLeft, _centerPoint.y)
    readonly property point _mappedBottomHandle: dataTransform.map(_bottomHandlePoint)
    readonly property point _mappedCenter: dataTransform.map(_centerPoint)
    readonly property point _mappedLeftHandle: dataTransform.map(_leftHandlePoint)
    readonly property point _mappedRightHandle: dataTransform.map(_rightHandlePoint)
    readonly property point _mappedTopHandle: dataTransform.map(_topHandlePoint)
    readonly property point _rightHandlePoint: Qt.point(_dataRight, _centerPoint.y)
    readonly property point _topHandlePoint: Qt.point(_centerPoint.x, _dataTop)
    /*!
        A direct reference to the bottom resize handle.
    */
    readonly property alias bottomHandle: bottomGraphHandle
    /*!
        Optional visual delegate used for cardinal resize handles.

        The delegate can read the handle state through \c parent.handle.
    */
    property Component cardinalHandleDelegate: null
    /*!
        The default shape used for cardinal resize handles.
    */
    property int cardinalHandleShape: GraphHandle.Square
    /*!
        Whether cardinal resize handles can resize the ellipse.
    */
    property bool cardinalHandlesMovable: true
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
        The ellipse bounding rectangle in data coordinates.
    */
    required property rect dataRect

    /*!
        Which built-in handles should be shown.
    */
    property int handleMode: EllipseHandles.Cardinal
    /*!
        The visual size and hit target size of cardinal resize handles.
    */
    property real handleSize: 8
    /*!
        GraphHandle objects rendered by this item.
    */
    readonly property var handles: [leftGraphHandle, rightGraphHandle, topGraphHandle, bottomGraphHandle, centerGraphHandle]

    /*!
        A direct reference to the left resize handle.
    */
    readonly property alias leftHandle: leftGraphHandle
    /*!
        The minimum height emitted when resize handles are dragged toward the opposite edge.
    */
    property real minimumDataHeight: 0
    /*!
        The minimum width emitted when resize handles are dragged toward the opposite edge.
    */
    property real minimumDataWidth: 0
    /*!
        Whether dragging the ellipse body should emit movement signals.
    */
    property bool movable: true
    /*!
        A direct reference to the right resize handle.
    */
    readonly property alias rightHandle: rightGraphHandle
    /*!
        A direct reference to the top resize handle.
    */
    readonly property alias topHandle: topGraphHandle

    /*!
        Emitted when the ellipse body has moved by \a delta in data coordinates.
    */
    signal moved(point delta)
    /*!
        Emitted when a handle has resized the ellipse to \a dataRect.
    */
    signal resized(rect dataRect)

    function _bodyScenePoint(localPoint) {
        return root.mapFromItem(bodyMouseArea, localPoint);
    }
    function _containsBodyPoint(localPoint) {
        return _containsBodyScenePoint(_bodyScenePoint(localPoint));
    }
    function _containsBodyScenePoint(scenePoint) {
        let radiusX = Math.abs(root._mappedRightHandle.x - root._mappedCenter.x);
        let radiusY = Math.abs(root._mappedTopHandle.y - root._mappedCenter.y);
        return QuickGraphLib.Helpers.isInsideEllipse(scenePoint, root._mappedCenter, radiusX, radiusY);
    }
    function _resizedFromHandle(handle, position) {
        let minimumWidth = Math.max(0, root.minimumDataWidth);
        let minimumHeight = Math.max(0, root.minimumDataHeight);
        if (handle.objectName === "left") {
            return QuickGraphLib.Helpers.clampedResizeRect(Qt.point(position.x, root._dataTop), Qt.point(root._dataRight, root._dataBottom), minimumWidth, 0, -1, -1);
        }
        if (handle.objectName === "right") {
            return QuickGraphLib.Helpers.clampedResizeRect(Qt.point(position.x, root._dataBottom), Qt.point(root._dataLeft, root._dataTop), minimumWidth, 0, 1, 1);
        }
        if (handle.objectName === "top") {
            return QuickGraphLib.Helpers.clampedResizeRect(Qt.point(root._dataLeft, position.y), Qt.point(root._dataRight, root._dataBottom), 0, minimumHeight, -1, -1);
        }
        if (handle.objectName === "bottom") {
            return QuickGraphLib.Helpers.clampedResizeRect(Qt.point(root._dataRight, position.y), Qt.point(root._dataLeft, root._dataTop), 0, minimumHeight, 1, 1);
        }
        return root.dataRect;
    }

    height: parent ? parent.height : 0
    width: parent ? parent.width : 0
    x: 0
    y: 0

    MouseArea {
        id: bodyMouseArea

        property real _bodyBottom: Math.max(root._mappedTopHandle.y, root._mappedBottomHandle.y)
        property real _bodyLeft: Math.min(root._mappedLeftHandle.x, root._mappedRightHandle.x)
        property real _bodyRight: Math.max(root._mappedLeftHandle.x, root._mappedRightHandle.x)
        property real _bodyTop: Math.min(root._mappedTopHandle.y, root._mappedBottomHandle.y)

        cursorShape: root.movable && (root._bodyHovered || root._bodyDragging) ? Qt.SizeAllCursor : Qt.ArrowCursor
        enabled: root.enabled
        height: _bodyBottom - _bodyTop
        hoverEnabled: true
        width: _bodyRight - _bodyLeft
        x: _bodyLeft
        y: _bodyTop

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
        id: leftGraphHandle

        cursorShape: Qt.SizeHorCursor
        dataTransform: root.dataTransform
        delegate: root.cardinalHandleDelegate
        fillColor: root.handleFillColor
        hoverFillColor: root.handleHoverFillColor
        movable: root.cardinalHandlesMovable
        objectName: "left"
        position: root._leftHandlePoint
        role: GraphHandle.Resize
        selected: root.selected
        selectedFillColor: root.handleSelectedFillColor
        shape: root.cardinalHandleShape
        size: root.handleSize
        strokeColor: root.handleStrokeColor
        strokeWidth: root.handleStrokeWidth
        visible: root.handlesVisible && root.handleMode !== EllipseHandles.NoHandles

        onClicked: root.handleClicked(leftGraphHandle)
        onMoved: position => {
            root.handleMoved(leftGraphHandle, position);
            root.resized(root._resizedFromHandle(leftGraphHandle, position));
        }
    }
    GraphHandle {
        id: rightGraphHandle

        cursorShape: Qt.SizeHorCursor
        dataTransform: root.dataTransform
        delegate: root.cardinalHandleDelegate
        fillColor: root.handleFillColor
        hoverFillColor: root.handleHoverFillColor
        movable: root.cardinalHandlesMovable
        objectName: "right"
        position: root._rightHandlePoint
        role: GraphHandle.Resize
        selected: root.selected
        selectedFillColor: root.handleSelectedFillColor
        shape: root.cardinalHandleShape
        size: root.handleSize
        strokeColor: root.handleStrokeColor
        strokeWidth: root.handleStrokeWidth
        visible: root.handlesVisible && root.handleMode !== EllipseHandles.NoHandles

        onClicked: root.handleClicked(rightGraphHandle)
        onMoved: position => {
            root.handleMoved(rightGraphHandle, position);
            root.resized(root._resizedFromHandle(rightGraphHandle, position));
        }
    }
    GraphHandle {
        id: topGraphHandle

        cursorShape: Qt.SizeVerCursor
        dataTransform: root.dataTransform
        delegate: root.cardinalHandleDelegate
        fillColor: root.handleFillColor
        hoverFillColor: root.handleHoverFillColor
        movable: root.cardinalHandlesMovable
        objectName: "top"
        position: root._topHandlePoint
        role: GraphHandle.Resize
        selected: root.selected
        selectedFillColor: root.handleSelectedFillColor
        shape: root.cardinalHandleShape
        size: root.handleSize
        strokeColor: root.handleStrokeColor
        strokeWidth: root.handleStrokeWidth
        visible: root.handlesVisible && root.handleMode !== EllipseHandles.NoHandles

        onClicked: root.handleClicked(topGraphHandle)
        onMoved: position => {
            root.handleMoved(topGraphHandle, position);
            root.resized(root._resizedFromHandle(topGraphHandle, position));
        }
    }
    GraphHandle {
        id: bottomGraphHandle

        cursorShape: Qt.SizeVerCursor
        dataTransform: root.dataTransform
        delegate: root.cardinalHandleDelegate
        fillColor: root.handleFillColor
        hoverFillColor: root.handleHoverFillColor
        movable: root.cardinalHandlesMovable
        objectName: "bottom"
        position: root._bottomHandlePoint
        role: GraphHandle.Resize
        selected: root.selected
        selectedFillColor: root.handleSelectedFillColor
        shape: root.cardinalHandleShape
        size: root.handleSize
        strokeColor: root.handleStrokeColor
        strokeWidth: root.handleStrokeWidth
        visible: root.handlesVisible && root.handleMode !== EllipseHandles.NoHandles

        onClicked: root.handleClicked(bottomGraphHandle)
        onMoved: position => {
            root.handleMoved(bottomGraphHandle, position);
            root.resized(root._resizedFromHandle(bottomGraphHandle, position));
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
        visible: root.handlesVisible && root.handleMode === EllipseHandles.CardinalAndCenter

        onClicked: root.handleClicked(centerGraphHandle)
        onMoved: position => {
            root.handleMoved(centerGraphHandle, position);
            root.moved(Qt.point(position.x - centerGraphHandle.position.x, position.y - centerGraphHandle.position.y));
        }
    }
}
