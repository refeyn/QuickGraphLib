// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import "RoiHitTest.js" as RoiHitTest

/*!
    \qmltype RectangleRoi
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Item
    \brief Interaction overlay for a rectangular region of interest.

    RectangleRoi provides selection, body dragging and optional corner handles for a rectangle.
    It does not own the rectangle data; instead it emits movement and resize signals so
    applications can update their own model.
*/

Item {
    id: root

    enum HandleMode {
        NoHandles,
        Corners,
        CornersAndCenter
    }

    property point _lastDragPoint: Qt.point(0, 0)

    readonly property real dataBottom: Math.max(dataRect.y, dataRect.y + dataRect.height)
    readonly property real dataLeft: Math.min(dataRect.x, dataRect.x + dataRect.width)
    readonly property real dataRight: Math.max(dataRect.x, dataRect.x + dataRect.width)
    readonly property real dataTop: Math.min(dataRect.y, dataRect.y + dataRect.height)

    readonly property point bottomLeftPoint: Qt.point(dataLeft, dataBottom)
    readonly property point bottomRightPoint: Qt.point(dataRight, dataBottom)
    readonly property point centerPoint: Qt.point((dataLeft + dataRight) / 2, (dataTop + dataBottom) / 2)
    readonly property point topLeftPoint: Qt.point(dataLeft, dataTop)
    readonly property point topRightPoint: Qt.point(dataRight, dataTop)

    readonly property point mappedBottomLeft: dataTransform.map(bottomLeftPoint)
    readonly property point mappedBottomRight: dataTransform.map(bottomRightPoint)
    readonly property point mappedTopLeft: dataTransform.map(topLeftPoint)
    readonly property point mappedTopRight: dataTransform.map(topRightPoint)

    /*!
        A direct reference to the top-left corner resize handle.
    */
    readonly property RoiHandle topLeftHandle: topLeftHandleSpec
    /*!
        A direct reference to the top-right corner resize handle.
    */
    readonly property RoiHandle topRightHandle: topRightHandleSpec
    /*!
        A direct reference to the bottom-left corner resize handle.
    */
    readonly property RoiHandle bottomLeftHandle: bottomLeftHandleSpec
    /*!
        A direct reference to the bottom-right corner resize handle.
    */
    readonly property RoiHandle bottomRightHandle: bottomRightHandleSpec
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
        The rectangle in data coordinates.
    */
    required property rect dataRect
    /*!
        Whether pressing the rectangle or handles should emit \l selectionRequested.
    */
    property bool selectable: true
    /*!
        Whether dragging the rectangle body should emit movement signals.
    */
    property bool movable: true
    /*!
        Whether corner handles can resize the rectangle.
    */
    property bool cornerHandlesMovable: true
    /*!
        Whether the ROI should be drawn in the selected state.
    */
    property bool selected: false
    /*!
        Whether handles should be visible.
    */
    property bool handlesVisible: selected
    /*!
        Which handles should be shown.
    */
    property int handleMode: RectangleRoi.Corners
    /*!
        Handle configuration objects rendered by this ROI.
    */
    property list<RoiHandle> handles: [
        RoiHandle {
            id: topLeftHandleSpec

            delegate: root.cornerHandleDelegate
            movable: root.cornerHandlesMovable
            name: "topLeft"
            position: root.topLeftPoint
            role: GraphHandle.Resize
            shape: root.cornerHandleShape
            size: root.handleSize
            visible: root.handlesVisible && root.handleMode !== RectangleRoi.NoHandles
        },
        RoiHandle {
            id: topRightHandleSpec

            delegate: root.cornerHandleDelegate
            movable: root.cornerHandlesMovable
            name: "topRight"
            position: root.topRightPoint
            role: GraphHandle.Resize
            shape: root.cornerHandleShape
            size: root.handleSize
            visible: root.handlesVisible && root.handleMode !== RectangleRoi.NoHandles
        },
        RoiHandle {
            id: bottomLeftHandleSpec

            delegate: root.cornerHandleDelegate
            movable: root.cornerHandlesMovable
            name: "bottomLeft"
            position: root.bottomLeftPoint
            role: GraphHandle.Resize
            shape: root.cornerHandleShape
            size: root.handleSize
            visible: root.handlesVisible && root.handleMode !== RectangleRoi.NoHandles
        },
        RoiHandle {
            id: bottomRightHandleSpec

            delegate: root.cornerHandleDelegate
            movable: root.cornerHandlesMovable
            name: "bottomRight"
            position: root.bottomRightPoint
            role: GraphHandle.Resize
            shape: root.cornerHandleShape
            size: root.handleSize
            visible: root.handlesVisible && root.handleMode !== RectangleRoi.NoHandles
        },
        RoiHandle {
            id: centerHandleSpec

            delegate: root.centerHandleDelegate
            movable: root.movable
            name: "center"
            position: root.centerPoint
            role: GraphHandle.Move
            shape: root.centerHandleShape
            size: root.centerHandleSize
            visible: root.handlesVisible && root.handleMode === RectangleRoi.CornersAndCenter
        }
    ]
    /*!
        The visual size and hit target size of corner handles.
    */
    property real handleSize: 12
    /*!
        The visual size and hit target size of the center handle.
    */
    property real centerHandleSize: handleSize
    /*!
        The default shape used for corner resize handles.
    */
    property int cornerHandleShape: GraphHandle.Square
    /*!
        The default shape used for the center move handle.
    */
    property int centerHandleShape: GraphHandle.Circle
    /*!
        Optional visual delegate used for corner resize handles.

        The delegate can read the handle state through \c parent.handle.
    */
    property Component cornerHandleDelegate: null
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
        The minimum width emitted when resize handles are dragged toward the opposite anchor.
    */
    property real minimumDataWidth: 0
    /*!
        The minimum height emitted when resize handles are dragged toward the opposite anchor.
    */
    property real minimumDataHeight: 0

    /*!
        Emitted when the ROI requests selection.
    */
    signal selectionRequested()
    /*!
        Emitted when the rectangle body has moved by \a delta in data coordinates.
    */
    signal moved(point delta)
    /*!
        Emitted when a corner handle has resized the rectangle to \a dataRect.
    */
    signal resized(rect dataRect)
    /*!
        Emitted when \a handle has moved to \a position in data coordinates.
    */
    signal handleMoved(RoiHandle handle, point position)

    function normalizedRect(point1, point2) {
        let left = Math.min(point1.x, point2.x);
        let right = Math.max(point1.x, point2.x);
        let top = Math.min(point1.y, point2.y);
        let bottom = Math.max(point1.y, point2.y);
        return Qt.rect(left, top, right - left, bottom - top);
    }

    function clampedResizePoint(position, anchor, xSign, ySign) {
        let minimumWidth = Math.max(0, root.minimumDataWidth);
        let minimumHeight = Math.max(0, root.minimumDataHeight);
        return Qt.point(
            xSign < 0
                ? Math.min(position.x, anchor.x - minimumWidth)
                : Math.max(position.x, anchor.x + minimumWidth),
            ySign < 0
                ? Math.min(position.y, anchor.y - minimumHeight)
                : Math.max(position.y, anchor.y + minimumHeight)
        );
    }

    function resizedFromHandle(handle, position) {
        if (handle.name === "topLeft") {
            return root.normalizedRect(
                root.clampedResizePoint(position, root.bottomRightPoint, -1, -1),
                root.bottomRightPoint
            );
        }
        if (handle.name === "topRight") {
            return root.normalizedRect(
                root.clampedResizePoint(position, root.bottomLeftPoint, 1, -1),
                root.bottomLeftPoint
            );
        }
        if (handle.name === "bottomLeft") {
            return root.normalizedRect(
                root.clampedResizePoint(position, root.topRightPoint, -1, 1),
                root.topRightPoint
            );
        }
        if (handle.name === "bottomRight") {
            return root.normalizedRect(
                root.clampedResizePoint(position, root.topLeftPoint, 1, 1),
                root.topLeftPoint
            );
        }
        return root.dataRect;
    }

    function bodyScenePoint(localPoint) {
        return Qt.point(bodyMouseArea.x + localPoint.x, bodyMouseArea.y + localPoint.y);
    }

    function containsBodyScenePoint(scenePoint) {
        return RoiHitTest.isInsidePolygon(scenePoint, [
            mappedTopLeft,
            mappedTopRight,
            mappedBottomRight,
            mappedBottomLeft
        ]);
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

        property real bodyLeft: Math.min(root.mappedTopLeft.x, root.mappedTopRight.x, root.mappedBottomLeft.x, root.mappedBottomRight.x)
        property real bodyRight: Math.max(root.mappedTopLeft.x, root.mappedTopRight.x, root.mappedBottomLeft.x, root.mappedBottomRight.x)
        property real bodyTop: Math.min(root.mappedTopLeft.y, root.mappedTopRight.y, root.mappedBottomLeft.y, root.mappedBottomRight.y)
        property real bodyBottom: Math.max(root.mappedTopLeft.y, root.mappedTopRight.y, root.mappedBottomLeft.y, root.mappedBottomRight.y)

        enabled: root.selectable || root.movable
        height: bodyBottom - bodyTop
        hoverEnabled: true
        cursorShape: root.movable ? Qt.SizeAllCursor : Qt.ArrowCursor
        width: bodyRight - bodyLeft
        x: bodyLeft
        y: bodyTop

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
