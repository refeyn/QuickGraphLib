// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS

/*!
    \qmltype AxVSpan
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays an vertical span.
*/

QQS.ShapePath {
    id: root

    readonly property point bottomRightPoint: dataTransform.map(Qt.point(xMax, viewRect.top))

    /*! TODO */
    required property matrix4x4 dataTransform
    readonly property point topLeftPoint: dataTransform.map(Qt.point(xMin, viewRect.bottom))
    /*! TODO */
    required property rect viewRect
    /*! TODO */
    required property double xMax
    /*! TODO */
    required property double xMin

    startX: topLeftPoint.x
    startY: topLeftPoint.y
    strokeColor: "transparent"

    PathLine {
        x: root.topLeftPoint.x
        y: root.bottomRightPoint.y + root.strokeWidth
    }
    // Would be much nicer to use PathMove, but then the whole rect is not filled
    PathLine {
        x: root.bottomRightPoint.x
        y: root.bottomRightPoint.y + root.strokeWidth
    }
    PathLine {
        x: root.bottomRightPoint.x
        y: root.topLeftPoint.y
    }
}
