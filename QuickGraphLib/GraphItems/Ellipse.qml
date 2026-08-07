// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS
import QuickGraphLib as QuickGraphLib

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

    readonly property real _dataBottom: _normalizedDataRect.bottom
    readonly property point _dataCenter: Qt.point((_normalizedDataRect.left + _normalizedDataRect.right) / 2, (_normalizedDataRect.top + _normalizedDataRect.bottom) / 2)
    readonly property real _dataLeft: _normalizedDataRect.left
    readonly property real _dataRight: _normalizedDataRect.right
    readonly property point _dataRightCenter: Qt.point(_dataRight, _dataCenter.y)
    readonly property real _dataTop: _normalizedDataRect.top
    readonly property point _dataTopCenter: Qt.point(_dataCenter.x, _dataTop)
    readonly property point _mappedCenter: dataTransform.map(_dataCenter)
    readonly property rect _mappedRect: dataTransform.mapRect(_normalizedDataRect)
    readonly property point _mappedRightCenter: dataTransform.map(_dataRightCenter)
    readonly property point _mappedTopCenter: dataTransform.map(_dataTopCenter)
    readonly property rect _normalizedDataRect: QuickGraphLib.Helpers.normalizedRect(dataRect)
    readonly property real _radiusX: _mappedRect.width / 2
    readonly property real _radiusY: _mappedRect.height / 2
    /*!
        The ellipse bounding rectangle in data coordinates.
    */
    required property rect dataRect

    /*!
        Must be assigned the data transform of the graph area this ellipse is paired to.

        \sa GraphArea::dataTransform
    */
    required property matrix4x4 dataTransform

    fillColor: "transparent"
    pathHints: QQS.ShapePath.PathConvex | QQS.ShapePath.PathSolid

    PathAngleArc {
        centerX: root._mappedCenter.x
        centerY: root._mappedCenter.y
        radiusX: root._radiusX
        radiusY: root._radiusY
        startAngle: 0
        sweepAngle: 360
    }
}
