// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

@Deprecated {
    reason: "Due to the new Qt 6.7 Curve renderer, this is no longer needed for antialiasing"
}

/*!
    \qmltype AntialiasingContainer
    \inqmlmodule QuickGraphLib
    \inherits QtQuick::Item
    \brief Enables antialiasing for it's contents.

    This item turns on \l {Multisample Antialiasing}. This helps with rendering in some cases.

    \deprecated [0.1.0a10] Due to the new Qt 6.7 Curve renderer, this is no longer needed for antialiasing.
        Replace with \l Item or remove completely
*/

Item {
    id: root

    /*!
        Whether MSAA antialiasing is enabled. This can help with rendering when the target display has a
        fractional scaling factor. It can also make rendering worse, especially with text. Defaults to \c false.
    */
    property alias antialiasingEnabled: root.layer.enabled

    implicitHeight: 100
    implicitWidth: 100
    layer.enabled: false //
    layer.samples: 2
}
