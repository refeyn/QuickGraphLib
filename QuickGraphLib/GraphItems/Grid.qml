// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS
import QuickGraphLib.GraphItems as QGLGraphItems

/*!
    \qmltype Grid
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays a grid in the background of a graph.
*/

QQS.ShapePath {
    id: root

    property QGLGraphItems.GridHelper _helper: QGLGraphItems.GridHelper {
        id: helper

    }

    /*!
        Must be assigned the data transform of the graph area this axis is paired to.

        \sa GraphArea::dataTransform
    */
    property alias dataTransform: helper.dataTransform
    /*!
        Must be assigned the view rect of the graph area this axis is paired to.

        \sa GraphArea::viewRect
    */
    property alias viewRect: helper.viewRect
    /*!
        The position of each X tick. This should be a list of doubles in data coordinates.

        \sa Helpers::range, Helpers::linspace, Axis::ticks
    */
    property alias xTicks: helper.xTicks
    /*!
        The position of each Y tick. This should be a list of doubles in data coordinates.

        \sa Helpers::range, Helpers::linspace, Axis::ticks
    */
    property alias yTicks: helper.yTicks

    capStyle: QQS.ShapePath.RoundCap
    fillColor: "transparent"
    joinStyle: QQS.ShapePath.RoundJoin

    PathMultiline {
        paths: helper.paths
    }
}
