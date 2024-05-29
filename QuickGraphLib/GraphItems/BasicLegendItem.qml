// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype BasicLegendItem
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Row
    \brief An single entry in a simple legend.
*/

Row {
    id: root

    /*! TODO */
    property color fillColor: "transparent"
    /*! TODO */
    property Gradient fillGradient: null
    /*! TODO */
    property color strokeColor: "black"
    /*! TODO */
    property real strokeWidth: 1
    /*! TODO */
    property alias text: label.text
    /*! TODO */
    property alias textColor: label.color
    /*! TODO */
    property alias textFont: label.font

    spacing: 2

    Item {
        id: clipper

        anchors.verticalCenter: parent.verticalCenter
        clip: true
        height: root.height - 2
        width: root.height - 2

        Rectangle {
            border.color: root.strokeColor
            border.width: root.strokeWidth
            color: root.fillColor
            gradient: root.fillGradient
            height: clipper.height / 2 + root.strokeWidth * 2
            width: clipper.width + root.strokeWidth * 4
            x: -root.strokeWidth * 2
            y: clipper.height / 2
        }
    }
    Text {
        id: label

        anchors.verticalCenter: parent.verticalCenter
    }
}
