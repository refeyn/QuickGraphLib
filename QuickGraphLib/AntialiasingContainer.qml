// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype AntialiasingContainer
    \inqmlmodule QuickGraphLib
    \inherits QtQuick::Item
    \brief Enables antialiasing for it's contents.
*/

Item {
    implicitHeight: 100
    implicitWidth: 100
    layer.enabled: true // Improves rendering of fractional DPIs
    layer.samples: 2
}
