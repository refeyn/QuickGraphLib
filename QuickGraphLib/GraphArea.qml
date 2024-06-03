// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS

/*!
    \qmltype Histogram
    \inqmlmodule QuickGraphLib
    \inherits QtQuick::Shapes::Shape
    \brief An area that graphs can be added to.
*/

QQS.Shape {
    id: root

    /*!
        Transform from data coordinates to pixel coordinates inside the GraphArea with the viewTransform applied
    */
    readonly property matrix4x4 dataTransform: viewTransform.times(rawDataTransform)
    /*!
        The view rect the view is actually showing based on viewTransform
    */
    readonly property rect effectiveViewRect: {
        let mat = rawDataTransform.inverted().times(viewTransform.inverted().times(rawDataTransform));
        // Map corners instead of the whole rect to preserve the invertedness of each axis
        let blCorner = mat.map(Qt.point(viewRect.x, viewRect.y));
        let trCorner = mat.map(Qt.point(viewRect.right, viewRect.bottom));
        return Qt.rect(blCorner.x, blCorner.y, trCorner.x - blCorner.x, trCorner.y - blCorner.y);
    }
    /*!
        Transform from data coordinates to pixel coordinates inside the GraphArea
    */
    readonly property matrix4x4 rawDataTransform: {
        let mat = Qt.matrix4x4();
        // Flip coordinate system so that Y points upwards
        mat.translate(Qt.vector3d(0, root.height, 0));
        mat.scale(root.width / viewRect.width, -root.height / viewRect.height, 1);
        mat.translate(Qt.vector3d(-viewRect.x, -viewRect.y, 0));
        return mat;
    }
    /*! TODO */
    required property rect viewRect
    /*! TODO */
    property matrix4x4 viewTransform

    function baseTransformFromRect(r: rect): matrix4x4 {
        let mat = Qt.matrix4x4();
        mat.scale(viewRect.width / r.width, viewRect.height / r.height, 1);
        mat.translate(Qt.vector3d((viewRect.x - r.x) / viewRect.width, (r.y + r.height - viewRect.y - viewRect.height) / viewRect.height, 0));
        return mat;
    }

    clip: true
    implicitHeight: 100
    implicitWidth: 100
}
