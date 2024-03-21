// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype AxVLine
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Rectangle
    \brief Displays an vertical line.
*/

Rectangle {
    id: root

    /*! TODO */
    required property matrix4x4 dataTransform
    /*! TODO */
    required property double position

    border.width: 0
    height: parent.height + border.width * 4
    width: 2
    x: root.dataTransform.map(Qt.point(position, 0)).x - width / 2
    y: -border.width * 2
}
