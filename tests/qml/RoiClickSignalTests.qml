// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib.GraphItems as QGLGraphItems

Item {
    id: root

    property int bodyClickCount: 0
    property bool clickedExpectedHandle: false
    property bool completedSuccessfully: true
    property string failureMessage: ""
    property int handleClickCount: 0
    readonly property matrix4x4 identityTransform: Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)

    height: 120
    width: 120

    QGLGraphItems.RectangleHandles {
        id: rectangleHandles

        dataRect: Qt.rect(20, 20, 60, 60)
        dataTransform: root.identityTransform
        handleMode: QGLGraphItems.RectangleHandles.Corners
        selected: true

        onBodyClicked: root.bodyClickCount += 1
        onHandleClicked: handle => {
            root.handleClickCount += 1;
            root.clickedExpectedHandle = handle === rectangleHandles.topLeftHandle;
        }
    }
}
