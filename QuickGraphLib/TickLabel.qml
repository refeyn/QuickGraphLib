// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype TickLabel
    \inqmlmodule QuickGraphLib
    \inherits Text
    \brief A single tick label.
*/

Text {
    /*! TODO */
    required property int decimalPoints
    /*! TODO */
    required property int direction
    /*! TODO */
    required property int index
    /*! TODO */
    required property point position
    /*! TODO */
    required property double value

    leftPadding: 2
    rightPadding: 2
    text: Number(value).toFixed(decimalPoints)
    x: {
        switch (direction) {
        case Axis.Direction.Left:
            return position.x - width;
        case Axis.Direction.Right:
            return position.x;
        case Axis.Direction.Top:
            return position.x - width / 2;
        case Axis.Direction.Bottom:
            return position.x - width / 2;
        }
    }
    y: {
        switch (direction) {
        case Axis.Direction.Left:
            return position.y - height / 2;
        case Axis.Direction.Right:
            return position.y - height / 2;
        case Axis.Direction.Top:
            return position.y - height;
        case Axis.Direction.Bottom:
            return position.y;
        }
    }
}
