// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype ZoomPanHandler
    \inqmlmodule QuickGraphLib
    \inherits QtQuick::PinchArea
    \brief Pinch/drag handling for graph or image zoom/pan interactions.
*/

PinchArea {
    id: root

    /*!
        The view transform, but in a pixel-independant form.
    */
    property matrix4x4 baseTransform
    /*!
        When set to true, translations will not be able to leave the original viewRect of the GraphArea.
    */
    property bool limitMovement: true
    /*!
        Maximum zoom (separate X/Y zoom limits can be set with the width/height of \l size).
    */
    property size maxScale: Qt.size(10, 10)
    /*!
        Minimum zoom (separate X/Y zoom limits can be set with the width/height of \l size).
    */
    property size minScale: Qt.size(1, 1)
    /*!
        The current view transform. This can be assigned to GraphArea::viewTransform.
    */
    readonly property matrix4x4 viewTransform: Qt.matrix4x4(baseTransform.m11, baseTransform.m12, baseTransform.m13, baseTransform.m14 * width, baseTransform.m21, baseTransform.m22, baseTransform.m23, baseTransform.m24 * height, baseTransform.m31, baseTransform.m32, baseTransform.m33, baseTransform.m34, baseTransform.m41, baseTransform.m42, baseTransform.m43, baseTransform.m44)
    /*!
        The amount to zoom in by for 15 degrees of mouse wheel movement.

        \sa QWheelEvent::angleDelta
    */
    property double wheelZoomFactor: 1.05

    function _applyLimitedMovement() {
        if (limitMovement) {
            // X bounds
            baseTransform.m14 = Math.min(0, Math.max(1 - baseTransform.m11, baseTransform.m14));
            // Y bounds
            baseTransform.m24 = Math.min(0, Math.max(1 - baseTransform.m22, baseTransform.m24));
        }
    }
    function _move(amount: vector3d) {
        let change = Qt.matrix4x4();
        change.translate(amount);
        baseTransform = change.times(baseTransform);
        _applyLimitedMovement();
    }
    function _zoom(center: vector3d, amount: double) {
        let change = Qt.matrix4x4();
        change.translate(center);
        let xScale = Math.min(Math.max(baseTransform.m11 * amount, minScale.width), maxScale.width) / baseTransform.m11;
        let yScale = Math.min(Math.max(baseTransform.m22 * amount, minScale.height), maxScale.height) / baseTransform.m22;
        change.scale(xScale, yScale, 1);
        change.translate(center.times(-1));
        baseTransform = change.times(baseTransform);
        _applyLimitedMovement();
    }
    function reset() {
        baseTransform = Qt.matrix4x4();
    }

    onPinchUpdated: pinch => root._zoom(Qt.vector3d(pinch.startCenter.x / width, pinch.startCenter.y / height, 0), pinch.scale / pinch.previousScale)

    MouseArea {
        id: dragArea

        property vector3d prevPosition

        anchors.fill: parent
        drag.filterChildren: true
        hoverEnabled: true

        onPositionChanged: mouse => {
            if (pressed) {
                let newPosition = Qt.vector3d(mouse.x / width, mouse.y / height, 0);
                root._move(newPosition.minus(prevPosition));
                prevPosition = newPosition;
            }
        }
        onPressed: prevPosition = Qt.vector3d(mouseX / width, mouseY / height, 0)
        onWheel: wheel => root._zoom(Qt.vector3d(mouseX / width, mouseY / height, 0), Math.pow(root.wheelZoomFactor, wheel.angleDelta.y / 15))
    }
}
