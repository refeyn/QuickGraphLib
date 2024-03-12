// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype AxHLine
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Rectangle
    \brief Displays a horizontal line.
*/

Rectangle {
    id: root

    /*! TODO */
    required property matrix4x4 dataTransform
    /*! TODO */
    required property double position

    height: 2
    width: parent.width + border.width * 4
    x: -border.width * 2
    y: root.dataTransform.map(Qt.point(0, position)).y - height / 2
}
