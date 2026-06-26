// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes as QQS
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems
import QuickGraphLib.PreFabs as QGLPreFabs

QGLPreFabs.XYAxes {
    id: axes

    property point editablePoint1: Qt.point(1, 1)
    property point editablePoint2: Qt.point(9, 6)
    property bool lineSegmentSelected: true

    viewRect: Qt.rect(-1, -1, 12, 8)
    xLabel: "X"
    yLabel: "Y"

    function moveEditableLineSegment(delta) {
        editablePoint1 = Qt.point(editablePoint1.x + delta.x, editablePoint1.y + delta.y);
        editablePoint2 = Qt.point(editablePoint2.x + delta.x, editablePoint2.y + delta.y);
    }

    QGLGraphItems.Line {
        dataTransform: axes.dataTransform
        path: QuickGraphLib.Helpers.linspace(0, 10, 80).map(x => Qt.point(x, 3 + 1.5 * Math.sin(x)))
        strokeColor: "black"
        strokeWidth: 2
    }
    QGLGraphItems.LineSegment {
        dataTransform: axes.dataTransform
        point1: axes.editablePoint1
        point2: axes.editablePoint2
        strokeColor: "black"
        strokeWidth: 4
    }
    QGLGraphItems.LineSegmentRoi {
        dataTransform: axes.dataTransform
        point1: axes.editablePoint1
        point2: axes.editablePoint2
        handleMode: QGLGraphItems.LineSegmentRoi.Endpoints
        movable: true
        selectable: true
        selected: axes.lineSegmentSelected

        onMoved: delta => axes.moveEditableLineSegment(delta)
        onPoint1Moved: position => axes.editablePoint1 = position
        onPoint2Moved: position => axes.editablePoint2 = position
        onSelectionRequested: axes.lineSegmentSelected = true
    }
    QGLGraphItems.LineSegment {
        dashPattern: [8, 4]
        dataTransform: axes.dataTransform
        point1: Qt.point(1, 6)
        point2: Qt.point(9, 1)
        strokeColor: "black"
        strokeStyle: QQS.ShapePath.DashLine
        strokeWidth: 3
    }
    QGLGraphItems.LineSegment {
        capStyle: QQS.ShapePath.FlatCap
        dataTransform: axes.dataTransform
        point1: Qt.point(2, 3.5)
        point2: Qt.point(8, 3.5)
        strokeColor: "black"
        strokeWidth: 8
    }
}
