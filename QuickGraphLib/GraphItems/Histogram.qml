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

    /*!
        List of doubles, representing the edges of each histogram bin. Should have a length equal to
        the length of \l heights plus one.
    */
    property alias bins: helper.bins
    /*!
        Must be assigned the data transform of the graph area this axis is paired to.

        \sa GraphArea::dataTransform
    */
    property alias dataTransform: helper.dataTransform
    /*!
        List of doubles, representing the height of each histogram bin. Should have a length equal to
        the length of \l bins minus one.
    */
    property alias heights: helper.heights
    /*!
        Whether to draw the histogram horizontally (i.e. \l bins are X positions) or vertically (i.e. \l bins are Y positions).
    */
    property alias vertical: helper.vertical

    capStyle: QQS.ShapePath.RoundCap
    joinStyle: QQS.ShapePath.RoundJoin

    PathPolyline {
        path: root._helper.path
    }
}
