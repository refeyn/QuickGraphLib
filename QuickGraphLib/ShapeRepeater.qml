// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQml.Models as QQM
import QtQuick.Shapes as QQS
import QuickGraphLib as QuickGraphLib

/*!
    \qmltype ShapeRepeater
    \inqmlmodule QuickGraphLib
    \inherits QtQml::Models::Instantiator
    \brief A \l{Repeater}-like component that works with \l{ShapePath}s.

    \sa {Scatter graph}
*/

QQM.Instantiator {
    id: root

    /*!
        The GraphArea to add children to.
    */
    required property QQS.Shape graphArea

    function forceResync() {
        if (graphArea.Window.window !== null) {
            let renderer = graphArea.preferredRendererType;
            let otherRenderer = graphArea.preferredRendererType === QQS.Shape.CurveRenderer ? QQS.Shape.GeometryRenderer : QQS.Shape.CurveRenderer;
            graphArea.preferredRendererType = otherRenderer;
            graphArea.ensurePolished();
            graphArea.preferredRendererType = renderer;
        }
    }

    onObjectAdded: (i, obj) => {
        QuickGraphLib.ShapeRepeaterHelper.insertObject(graphArea, root, obj, i);
        forceResync();
    }
    onObjectRemoved: (i, obj) => {
        QuickGraphLib.ShapeRepeaterHelper.removeObject(graphArea, obj);
        forceResync();
    }
}
