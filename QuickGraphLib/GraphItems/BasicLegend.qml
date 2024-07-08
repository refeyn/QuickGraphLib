// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype BasicLegend
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Rectangle
    \brief Displays a simple legend.

    \note This graph item does not inherit from ShapePath, unlike other graph items.
*/

Rectangle {
    /*!
        The legend items. This should be l\ {BasicLegendItem}s.
    */
    default property alias contentChildren: legend.children
    /*!
        The spacing between each legend item.
    */
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
