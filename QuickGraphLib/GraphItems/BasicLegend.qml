// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype BasicLegend
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Rectangle
    \brief Displays a simple legend.
*/

Rectangle {
    /*! TODO */
    default property alias contentChildren: legend.children
    /*! TODO */
    property alias verticalSpacing: legend.spacing

    border.color: "black"
    color: "#aaffffff"
    height: legend.height + 10
    width: legend.width + 10

    Column {
        id: legend

        anchors.centerIn: parent
    }
}
