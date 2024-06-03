// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS

/*!
    \qmltype AxHLine
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays a horizontal line.
*/

QQS.ShapePath {
    id: root

    readonly property point bottomRightPoint: dataTransform.map(Qt.point(viewRect.right, position))

    /*! TODO */
    required property matrix4x4 dataTransform
    /*! TODO */
    required property double position
    readonly property point topLeftPoint: dataTransform.map(Qt.point(viewRect.left, position))
    /*! TODO */
    required property rect viewRect

    startX: topLeftPoint.x
    startY: topLeftPoint.y

    PathLine {
        x: root.bottomRightPoint.x
        y: root.topLeftPoint.y
    }
}
