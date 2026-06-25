// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS

/*!
    \qmltype Ellipse
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays an ellipse in data coordinates.

    Draws an ellipse from a bounding Qt rect in data coordinates. The style can be adjusted using the
    \l {ShapePath::fillColor} {fillColor}, \l {ShapePath::strokeColor} {strokeColor} and
    \l {ShapePath::strokeWidth} {strokeWidth} properties.
*/

QQS.ShapePath {
    id: root

    readonly property real dataBottom: Math.max(dataRect.y, dataRect.y + dataRect.height)
    readonly property real dataLeft: Math.min(dataRect.x, dataRect.x + dataRect.width)
    readonly property real dataRight: Math.max(dataRect.x, dataRect.x + dataRect.width)
    readonly property real dataTop: Math.min(dataRect.y, dataRect.y + dataRect.height)

    readonly property point dataCenter: Qt.point((dataLeft + dataRight) / 2, (dataTop + dataBottom) / 2)
    readonly property point dataRightCenter: Qt.point(dataRight, dataCenter.y)
    readonly property point dataTopCenter: Qt.point(dataCenter.x, dataTop)
    readonly property point mappedCenter: dataTransform.map(dataCenter)
    readonly property point mappedRightCenter: dataTransform.map(dataRightCenter)
    readonly property point mappedTopCenter: dataTransform.map(dataTopCenter)
    readonly property real radiusX: Math.abs(mappedRightCenter.x - mappedCenter.x)
    readonly property real radiusY: Math.abs(mappedTopCenter.y - mappedCenter.y)

    /*!
        Must be assigned the data transform of the graph area this ellipse is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform
    /*!
        The ellipse bounding rectangle in data coordinates.
    */
    required property rect dataRect

    fillColor: "transparent"
    pathHints: QQS.ShapePath.PathConvex | QQS.ShapePath.PathSolid
    startX: mappedCenter.x + radiusX
    startY: mappedCenter.y

    PathAngleArc {
        centerX: root.mappedCenter.x
        centerY: root.mappedCenter.y
        radiusX: root.radiusX
        radiusY: root.radiusY
        startAngle: 0
        sweepAngle: 360
    }
}
