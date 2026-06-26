// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype RoiHandle
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQml::QtObject
    \brief Configuration object for a region-of-interest handle.

    RoiHandle describes where a handle is, what role it has, and how it should be displayed.
    ROI items expose lists of these objects so applications can show, hide, replace, or restyle
    individual handles.
*/

QtObject {
    id: root

    /*!
        Stable application-facing name for this handle.
    */
    property string name: ""
    /*!
        The semantic editing role of this handle.
    */
    property int role: GraphHandle.Custom
    /*!
        The handle position in data coordinates.
    */
    property point position: Qt.point(0, 0)
    /*!
        Whether this handle should be shown.
    */
    property bool visible: true
    /*!
        Whether this handle can be dragged.
    */
    property bool movable: true
    /*!
        Whether pressing this handle should request ROI selection.
    */
    property bool selectable: true
    /*!
        Whether this individual handle should be drawn in the selected style.
    */
    property bool selected: false
    /*!
        The mouse cursor shown while hovering this handle.
    */
    property int cursorShape: Qt.SizeAllCursor
    /*!
        The visual size of this handle.
    */
    property real size: 12
    /*!
        The mouse hit target size of this handle.
    */
    property real hitSize: size
    /*!
        The default visual shape of this handle.
    */
    property int shape: GraphHandle.Circle
    /*!
        Optional visual delegate for this handle.
    */
    property Component delegate: null
}
