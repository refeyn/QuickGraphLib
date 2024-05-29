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

    /*! TODO */
    property alias dataTransform: helper.dataTransform
    /*! TODO */
    property alias viewRect: helper.viewRect
    /*! TODO */
    property alias xTicks: helper.xTicks
    /*! TODO */
    property alias yTicks: helper.yTicks

    capStyle: QQS.ShapePath.RoundCap
    fillColor: "transparent"
    joinStyle: QQS.ShapePath.RoundJoin

    PathMultiline {
        paths: helper.paths
    }
}
