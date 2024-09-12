// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype AntialiasingContainer
    \inqmlmodule QuickGraphLib
    \inherits QtQuick::Item
    \brief Enables antialiasing for it's contents.

    This item turns on \l {Multisample Antialiasing}. This helps with rendering in some cases.
*/

Item {
    id: root

    /*!
        Whether MSAA antialiasing is enabled. This can help with rendering when the target display has a
        fractional scaling factor. It can also make rendering worse, especially with text.
    */
    property alias antialiasingEnabled: root.layer.enabled

    implicitHeight: 100
    implicitWidth: 100
    layer.enabled: false //
    layer.samples: 2
}
