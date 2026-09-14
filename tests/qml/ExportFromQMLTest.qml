// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QuickGraphLib as QuickGraphLib
import Tests as Tests

Window {
    id: root

    required property url exampleUrl
    property bool hasExported: false
    required property url outputGrabUrl
    required property url outputPictureUrl
    required property url outputPngUrl
    required property url outputSvgUrl

    height: 600
    visible: true
    width: 800

    onFrameSwapped: {
        if (root.hasExported || loader.status != Loader.Ready)
            return;
        content.ensurePolished();
        let res = content.grabToImage(result => {
            result.saveToFile(root.outputGrabUrl);
            Qt.exit(0);
        });
        if (!res) {
            Qt.exit(1);
        }
        QuickGraphLib.Helpers.exportToPng(content, root.outputPngUrl);
        QuickGraphLib.Helpers.exportToSvg(content, root.outputSvgUrl);
        Tests.PictureSaver.savePicture(QuickGraphLib.Helpers.exportToPicture(content), root.outputPictureUrl);
        root.hasExported = true;
    }

    Rectangle {
        id: content

        anchors.fill: parent
        border.width: 0
        color: "white"

        Loader {
            id: loader

            anchors.fill: parent
            asynchronous: true
            source: exampleUrl
        }
    }
}
