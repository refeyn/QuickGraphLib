// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

Rectangle {
    id: root

    required property url exampleUrl

    border.width: 0
    color: "white"

    Loader {
        anchors.fill: parent
        source: root.exampleUrl
    }
}
