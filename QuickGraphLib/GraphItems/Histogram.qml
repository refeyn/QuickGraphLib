// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS
import QuickGraphLib.GraphItems as QGLGraphItems

/*!
    \qmltype Histogram
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays a histogram.
*/

QQS.ShapePath {
    id: root

    property QGLGraphItems.HistogramHelper _helper: QGLGraphItems.HistogramHelper {
        id: helper

        vertical: false
    }

    /*! TODO */
    property alias bins: helper.bins
    /*! TODO */
    property alias dataTransform: helper.dataTransform
    /*! TODO */
    property alias heights: helper.heights
    /*! TODO */
    property alias vertical: helper.vertical

    capStyle: QQS.ShapePath.RoundCap
    joinStyle: QQS.ShapePath.RoundJoin

    PathPolyline {
        path: root._helper.path
    }
}
