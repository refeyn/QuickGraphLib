// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS

/*!
    \qmltype AxVLine
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Rectangle
    \brief Displays an vertical line.
*/

QQS.ShapePath {
    id: root

    readonly property point bottomRightPoint: dataTransform.map(Qt.point(position, viewRect.top))

    /*! TODO */
    required property matrix4x4 dataTransform
    /*! TODO */
    required property double position
    readonly property point topLeftPoint: dataTransform.map(Qt.point(position, viewRect.bottom))
    /*! TODO */
    required property rect viewRect

    startX: topLeftPoint.x
    startY: topLeftPoint.y

    PathLine {
        x: root.topLeftPoint.x
        y: root.bottomRightPoint.y + root.strokeWidth
    }
}
