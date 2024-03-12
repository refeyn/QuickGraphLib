// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS

/*!
    \qmltype Grid
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays a grid in the background of a graph.
*/

QQS.ShapePath {
    id: root

    /*! TODO */
    required property matrix4x4 dataTransform
    /*! TODO */
    required property double parentHeight
    /*! TODO */
    required property double parentWidth
    /*! TODO */
    property list<double> xTicks: []
    /*! TODO */
    property list<double> yTicks: []

    function _calculateXPath(xTicks, dataTransform, parentHeight) {
        let points = [];
        xTicks.forEach(t => {
            let x = dataTransform.map(Qt.point(t, 0)).x;
            points.push(Qt.point(x, -10));
            points.push(Qt.point(x, parentHeight + 10));
            points.push(Qt.point(x, -10));
        });
        return points;
    }
    function _calculateYPath(yTicks, dataTransform, parentWidth) {
        let points = [];
        yTicks.forEach(t => {
            let y = dataTransform.map(Qt.point(0, t)).y;
            points.push(Qt.point(-10, y));
            points.push(Qt.point(parentWidth + 10, y));
            points.push(Qt.point(-10, y));
        });
        return points;
    }

    capStyle: QQS.ShapePath.RoundCap
    joinStyle: QQS.ShapePath.RoundJoin

    PathPolyline {
        path: root._calculateXPath(root.xTicks, root.dataTransform, root.parentHeight)
    }
    PathPolyline {
        path: root._calculateYPath(root.yTicks, root.dataTransform, root.parentWidth)
    }
}
