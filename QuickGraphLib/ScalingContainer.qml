// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype ScalingContainer
    \inqmlmodule QuickGraphLib
    \inherits AntialiasingContainer
    \brief Scales it's contents while preserving the aspect ratio.
*/

AntialiasingContainer {
    id: container

    /*! TODO */
    default property alias contentChildren: graph.children
    /*! TODO */
    property alias contentHeight: graph.height
    /*! TODO */
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
