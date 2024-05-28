// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype TickLabel
    \inqmlmodule QuickGraphLib
    \inherits Text
    \brief A single tick label
*/

Text {
    required property int decimalPoints
    required property int direction
    required property int index
    required property point position
    required property double value

    leftPadding: 2
    rightPadding: 2
    text: Number(value).toFixed(decimalPoints)
    x: {
        let baseX = position.x;
        switch (direction) {
        case Axis.Direction.Left:
            return baseX - width;
        case Axis.Direction.Right:
            return baseX;
        case Axis.Direction.Top:
            return baseX - width / 2;
        case Axis.Direction.Bottom:
            return baseX - width / 2;
        }
    }
    y: {
        let baseY = position.y;
        switch (direction) {
        case Axis.Direction.Left:
            return baseY - height / 2;
        case Axis.Direction.Right:
            return baseY - height / 2;
        case Axis.Direction.Top:
            return baseY - height;
        case Axis.Direction.Bottom:
            return baseY;
        }
    }
}
