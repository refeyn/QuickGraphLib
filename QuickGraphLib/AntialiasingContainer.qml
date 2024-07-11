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
        Whether MSAA antialiasing is enabled.
    */
    property alias antialiasingEnabled: root.layer.enabled

    implicitHeight: 100
    implicitWidth: 100
    layer.enabled: true // Improves rendering of fractional DPIs
    layer.samples: 2
}
