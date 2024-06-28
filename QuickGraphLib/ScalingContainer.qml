// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype ScalingContainer
    \inqmlmodule QuickGraphLib
    \inherits AntialiasingContainer
    \brief Scales its contents while preserving the aspect ratio.

    This container applies a scaling factor to its content item that preserves its aspect ratio.
*/

AntialiasingContainer {
    id: container

    /*!
        The children of the content item.
    */
    default property alias contentChildren: graph.children
    /*!
        The height of the content item.
    */
    property alias contentHeight: graph.height
    /*!
        The width of the content item.
    */
    property alias contentWidth: graph.width

    implicitHeight: 100
    implicitWidth: 100

    Item {
        id: graph

        anchors.centerIn: parent

        transform: Scale {
            origin.x: graph.width / 2
            origin.y: graph.height / 2
            xScale: Math.min(container.width / graph.width, container.height / graph.height)
            yScale: Math.min(container.width / graph.width, container.height / graph.height)
        }
    }
}
