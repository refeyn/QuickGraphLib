// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib.GraphItems as QGLGraphItems

Item {
    id: root

    property int bodyPressCount: 0
    property bool completedSuccessfully: false
    property string failureMessage: ""
    property int handleClickCount: 0
    readonly property matrix4x4 identityTransform: Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)

    height: 100
    width: 100

    Component.onCompleted: {
        try {
            if (defaultHandle.z !== 10) {
                throw new Error("GraphHandle default z mismatch");
            }
            if (overriddenHandle.z !== 25) {
                throw new Error("explicit GraphHandle z override mismatch");
            }
            completedSuccessfully = true;
        } catch (error) {
            failureMessage = error.toString();
        }
    }

    QGLGraphItems.GraphHandle {
        id: defaultHandle

        dataTransform: root.identityTransform
        position: Qt.point(25, 25)

        onClicked: root.handleClickCount += 1
    }
    QGLGraphItems.GraphHandle {
        id: overriddenHandle

        dataTransform: root.identityTransform
        position: Qt.point(75, 75)
        z: 25
    }
    MouseArea {
        anchors.fill: parent

        onPressed: root.bodyPressCount += 1
    }
}
