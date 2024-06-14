// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQml.Models as QQM
import QtQuick.Shapes as QQS

/*!
    \qmltype ShapeRepeater
    \inqmlmodule QuickGraphLib
    \inherits QtQml::Models::Instantiator
    \brief A \l{Repeater}-like component that works with \l{ShapePath}s.
*/

QQM.Instantiator {
    required property QQS.Shape graphArea

    onObjectAdded: (i, obj) => graphArea.data.push(obj)
    onObjectRemoved: (i, obj) => {
        // Remove everything into a JS array and then add back in all items except for `obj`
        graphArea.data.splice(0, graphArea.data.length).filter(o => o !== obj).map(x => graphArea.data.push(x));
    }
}
