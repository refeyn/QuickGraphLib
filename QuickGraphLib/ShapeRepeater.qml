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

    See the \l{Repeater} documentation for the general concept, and how to access data from the \l Instantiator::model.

    If the ShapeRepeater is a child of the \l GraphArea provided to \l graphArea, then paths
    the ShapeRepeater instantiates will be inserted, in order, immediately after the repeater's
    position in the list of shape paths.

    \sa {Peak buttons}
*/

QQM.Instantiator {
    id: root

    /*!
        The GraphArea to add paths to.
    */
    required property QQS.Shape graphArea

    function forceResync() {
        // Workaround for https://bugreports.qt.io/browse/QTBUG-133230 and https://bugreports.qt.io/browse/QTBUG-133231
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
