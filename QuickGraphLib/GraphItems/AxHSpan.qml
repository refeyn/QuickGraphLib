// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS

/*!
    \qmltype AxHSpan
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays a horizontal span.
*/

QQS.ShapePath {
    id: root

    readonly property point bottomRightPoint: dataTransform.map(Qt.point(viewRect.right, yMin))

    /*! TODO */
    required property matrix4x4 dataTransform
    readonly property point topLeftPoint: dataTransform.map(Qt.point(viewRect.left, yMax))
    /*! TODO */
    required property rect viewRect
    /*! TODO */
    required property double yMax
    /*! TODO */
    required property double yMin

    startX: topLeftPoint.x
    startY: topLeftPoint.y
    strokeColor: "transparent"

    PathLine {
        x: root.bottomRightPoint.x + root.strokeWidth
        y: root.topLeftPoint.y
    }
    // Would be much nicer to use PathMove, but then the whole rect is not filled
    PathLine {
        x: root.bottomRightPoint.x + root.strokeWidth
        y: root.bottomRightPoint.y
    }
    PathLine {
        x: root.topLeftPoint.x
        y: root.bottomRightPoint.y
    }
}
