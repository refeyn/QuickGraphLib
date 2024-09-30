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
        Transform from data coordinates to pixel coordinates inside the GraphArea with the viewTransform applied.
    */
    readonly property matrix4x4 dataTransform: viewTransform.times(rawDataTransform)
    /*!
        The view rect the view is actually showing based on viewTransform.
    */
    readonly property rect effectiveViewRect: {
        let mat = rawDataTransform.inverted().times(viewTransform.inverted().times(rawDataTransform));
        // Map corners instead of the whole rect to preserve the invertedness of each axis
        let blCorner = mat.map(Qt.point(viewRect.x, viewRect.y));
        let trCorner = mat.map(Qt.point(viewRect.right, viewRect.bottom));
        return Qt.rect(blCorner.x, blCorner.y, trCorner.x - blCorner.x, trCorner.y - blCorner.y);
    }
    /*!
        Transform from data coordinates to pixel coordinates inside the GraphArea.
    */
    readonly property matrix4x4 rawDataTransform: {
        let mat = Qt.matrix4x4();
        // Flip coordinate system so that Y points upwards
        mat.translate(Qt.vector3d(0, root.height, 0));
        mat.scale(root.width / viewRect.width, -root.height / viewRect.height, 1);
        mat.translate(Qt.vector3d(-viewRect.x, -viewRect.y, 0));
        return mat;
    }
    /*!
        The area in data coordinates that the graph covers.
    */
    required property rect viewRect
    /*!
        An additional transform that can be used to zoom/translate the graph area without affecting the original view rect.

        \sa ZoomPanHandler::viewTransform, viewTransformFromRect
    */
    property matrix4x4 viewTransform

    /*!
        Convert a view rect \a r into a base transform suitable for use with a ZoomPanHandler.

        \sa ZoomPanHandler::baseTransform
    */
    function baseTransformFromRect(r: rect): matrix4x4 {
        let mat = Qt.matrix4x4();
        mat.scale(viewRect.width / r.width, viewRect.height / r.height, 1);
        mat.translate(Qt.vector3d((viewRect.x - r.x) / viewRect.width, (r.y + r.height - viewRect.y - viewRect.height) / viewRect.height, 0));
        return mat;
    }

    /*!
        Convert a base transform \a baseTransform into a view transform suitable for \l viewTransform.
    */
    function viewTransformFromBaseTransform(baseTransform: matrix4x4): matrix4x4 {
        return Qt.matrix4x4(baseTransform.m11, baseTransform.m12, baseTransform.m13, baseTransform.m14 * width, baseTransform.m21, baseTransform.m22, baseTransform.m23, baseTransform.m24 * height, baseTransform.m31, baseTransform.m32, baseTransform.m33, baseTransform.m34, baseTransform.m41, baseTransform.m42, baseTransform.m43, baseTransform.m44);
    }

    /*!
        Convert a view rect \a r into a view transform suitable for \l viewTransform.
    */
    function viewTransformFromRect(r: rect): matrix4x4 {
        return viewTransformFromBaseTransform(baseTransformFromRect(r));
    }

    clip: true
    implicitHeight: 100
    implicitWidth: 100
}
