// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype TickLabel
    \inqmlmodule QuickGraphLib
    \inherits Text
    \brief A single tick label.

    This is the default implementation of a tick label. To customise how labels are shown,
    you can subclass this and override the \l Text::text property.
*/

Text {
    /*!
        Number of decimal points to show.
    */
    required property int decimalPoints
    /*!
        The direction of the Axis this tick is part of.

        \sa Axis::direction
    */
    required property int direction
    /*!
        The position of the tick in pixels.
    */
    required property point position
    /*!
        The data value of the tick.
    */
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
