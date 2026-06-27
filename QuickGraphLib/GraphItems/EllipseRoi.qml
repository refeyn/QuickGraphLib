// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import "RoiHitTest.js" as RoiHitTest

/*!
    \qmltype EllipseRoi
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Item
    \brief Interaction overlay for an elliptical region of interest.

    EllipseRoi provides selection, body dragging and optional cardinal resize handles for an
    ellipse. It does not own the ellipse data; instead it emits movement and resize signals so
    applications can update their own model.
*/

Item {
    id: root

    enum HandleMode {
        NoHandles,
        Cardinal,
        CardinalAndCenter
    }

    property bool _bodyDragging: false
    property bool _bodyHovered: false
    property point _lastDragPoint: Qt.point(0, 0)
    /*!
        A direct reference to the bottom resize handle.
    */
    readonly property RoiHandle bottomHandle: bottomHandleSpec
    readonly property point bottomHandlePoint: Qt.point(centerPoint.x, dataBottom)
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
    readonly property RoiHandle centerHandle: centerHandleSpec
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
    readonly property point centerPoint: Qt.point((dataLeft + dataRight) / 2, (dataTop + dataBottom) / 2)
    readonly property real dataBottom: Math.max(dataRect.y, dataRect.y + dataRect.height)
    readonly property real dataLeft: Math.min(dataRect.x, dataRect.x + dataRect.width)
    /*!
        The ellipse bounding rectangle in data coordinates.
    */
    required property rect dataRect
    readonly property real dataRight: Math.max(dataRect.x, dataRect.x + dataRect.width)
    readonly property real dataTop: Math.min(dataRect.y, dataRect.y + dataRect.height)

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
        The handle fill color used while hovered.
    */
    property color handleHoverFillColor: "#fff6bf"
    /*!
        Which built-in handles should be shown.
    */
    property int handleMode: EllipseRoi.Cardinal
    /*!
        The handle fill color used while selected or dragged.
    */
    property color handleSelectedFillColor: "#ffd24d"
    /*!
        The visual size and hit target size of cardinal resize handles.
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
    property list<RoiHandle> handles: [
        RoiHandle {
            id: leftHandleSpec

            cursorShape: Qt.SizeHorCursor
            delegate: root.cardinalHandleDelegate
            movable: root.cardinalHandlesMovable
            name: "left"
            position: root.leftHandlePoint
            role: GraphHandle.Resize
            shape: root.cardinalHandleShape
            size: root.handleSize
            visible: root.handlesVisible && root.handleMode !== EllipseRoi.NoHandles
        },
        RoiHandle {
            id: rightHandleSpec

            cursorShape: Qt.SizeHorCursor
            delegate: root.cardinalHandleDelegate
            movable: root.cardinalHandlesMovable
            name: "right"
            position: root.rightHandlePoint
            role: GraphHandle.Resize
            shape: root.cardinalHandleShape
            size: root.handleSize
            visible: root.handlesVisible && root.handleMode !== EllipseRoi.NoHandles
        },
        RoiHandle {
            id: topHandleSpec

            cursorShape: Qt.SizeVerCursor
            delegate: root.cardinalHandleDelegate
            movable: root.cardinalHandlesMovable
            name: "top"
            position: root.topHandlePoint
            role: GraphHandle.Resize
            shape: root.cardinalHandleShape
            size: root.handleSize
            visible: root.handlesVisible && root.handleMode !== EllipseRoi.NoHandles
        },
        RoiHandle {
            id: bottomHandleSpec

            cursorShape: Qt.SizeVerCursor
            delegate: root.cardinalHandleDelegate
            movable: root.cardinalHandlesMovable
            name: "bottom"
            position: root.bottomHandlePoint
            role: GraphHandle.Resize
            shape: root.cardinalHandleShape
            size: root.handleSize
            visible: root.handlesVisible && root.handleMode !== EllipseRoi.NoHandles
        },
        RoiHandle {
            id: centerHandleSpec

            cursorShape: Qt.SizeAllCursor
            delegate: root.centerHandleDelegate
            movable: root.movable
            name: "center"
            position: root.centerPoint
            role: GraphHandle.Move
            shape: root.centerHandleShape
            size: root.centerHandleSize
            visible: root.handlesVisible && root.handleMode === EllipseRoi.CardinalAndCenter
        }
    ]
    /*!
        Whether handles should be visible.
    */
    property bool handlesVisible: selected

    /*!
        A direct reference to the left resize handle.
    */
    readonly property RoiHandle leftHandle: leftHandleSpec
    readonly property point leftHandlePoint: Qt.point(dataLeft, centerPoint.y)
    readonly property point mappedBottomHandle: dataTransform.map(bottomHandlePoint)
    readonly property point mappedCenter: dataTransform.map(centerPoint)
    readonly property point mappedLeftHandle: dataTransform.map(leftHandlePoint)
    readonly property point mappedRightHandle: dataTransform.map(rightHandlePoint)
    readonly property point mappedTopHandle: dataTransform.map(topHandlePoint)
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
    readonly property RoiHandle rightHandle: rightHandleSpec
    readonly property point rightHandlePoint: Qt.point(dataRight, centerPoint.y)
    /*!
        Whether pressing the ellipse or handles should emit \l selectionRequested.
    */
    property bool selectable: true
    /*!
        Whether the ROI should be drawn in the selected state.
    */
    property bool selected: false
    /*!
        A direct reference to the top resize handle.
    */
    readonly property RoiHandle topHandle: topHandleSpec
    readonly property point topHandlePoint: Qt.point(centerPoint.x, dataTop)

    /*!
        Emitted when \a handle has moved to \a position in data coordinates.
    */
    signal handleMoved(RoiHandle handle, point position)
    /*!
        Emitted when the ellipse body has moved by \a delta in data coordinates.
    */
    signal moved(point delta)
    /*!
        Emitted when a handle has resized the ellipse to \a dataRect.
    */
    signal resized(rect dataRect)

    /*!
        Emitted when the ROI requests selection.
    */
    signal selectionRequested

    function bodyScenePoint(localPoint) {
        return Qt.point(bodyMouseArea.x + localPoint.x, bodyMouseArea.y + localPoint.y);
    }
    function containsBodyPoint(localPoint) {
        return containsBodyScenePoint(bodyScenePoint(localPoint));
    }
    function containsBodyScenePoint(scenePoint) {
        let radiusX = Math.abs(root.mappedRightHandle.x - root.mappedCenter.x);
        let radiusY = Math.abs(root.mappedTopHandle.y - root.mappedCenter.y);
        return RoiHitTest.isInsideEllipse(scenePoint, root.mappedCenter, radiusX, radiusY);
    }
    function normalizedRect(left, top, right, bottom) {
        let normalizedLeft = Math.min(left, right);
        let normalizedRight = Math.max(left, right);
        let normalizedTop = Math.min(top, bottom);
        let normalizedBottom = Math.max(top, bottom);
        return Qt.rect(normalizedLeft, normalizedTop, normalizedRight - normalizedLeft, normalizedBottom - normalizedTop);
    }
    function resizedFromHandle(handle, position) {
        let minimumWidth = Math.max(0, root.minimumDataWidth);
        let minimumHeight = Math.max(0, root.minimumDataHeight);
        if (handle.name === "left") {
            return normalizedRect(Math.min(position.x, root.dataRight - minimumWidth), root.dataTop, root.dataRight, root.dataBottom);
        }
        if (handle.name === "right") {
            return normalizedRect(root.dataLeft, root.dataTop, Math.max(position.x, root.dataLeft + minimumWidth), root.dataBottom);
        }
        if (handle.name === "top") {
            return normalizedRect(root.dataLeft, Math.min(position.y, root.dataBottom - minimumHeight), root.dataRight, root.dataBottom);
        }
        if (handle.name === "bottom") {
            return normalizedRect(root.dataLeft, root.dataTop, root.dataRight, Math.max(position.y, root.dataTop + minimumHeight));
        }
        return root.dataRect;
    }

    height: parent ? parent.height : 0
    width: parent ? parent.width : 0
    x: 0
    y: 0

    MouseArea {
        id: bodyMouseArea

        property real bodyBottom: Math.max(root.mappedTopHandle.y, root.mappedBottomHandle.y)
        property real bodyLeft: Math.min(root.mappedLeftHandle.x, root.mappedRightHandle.x)
        property real bodyRight: Math.max(root.mappedLeftHandle.x, root.mappedRightHandle.x)
        property real bodyTop: Math.min(root.mappedTopHandle.y, root.mappedBottomHandle.y)

        cursorShape: root.movable && (root._bodyHovered || root._bodyDragging) ? Qt.SizeAllCursor : Qt.ArrowCursor
        enabled: root.selectable || root.movable
        height: bodyBottom - bodyTop
        hoverEnabled: true
        width: bodyRight - bodyLeft
        x: bodyLeft
        y: bodyTop

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
            root.handleMoved(handle, position);
            if (handle.role === GraphHandle.Resize) {
                root.resized(root.resizedFromHandle(handle, position));
            } else if (handle.role === GraphHandle.Move) {
                root.moved(Qt.point(position.x - handle.position.x, position.y - handle.position.y));
            }
        }
        onHandleSelectionRequested: handle => root.selectionRequested()
    }
}
