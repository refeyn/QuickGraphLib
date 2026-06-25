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

    Component {
        id: moveHandleDelegate

        Rectangle {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            border.color: "#333333"
            border.width: parent.handle.strokeWidth
            color: parent.handle.dragging || parent.handle.selected ? "#ffe680" : "#f7f7f7"
            radius: 2

            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 6
                height: 2
                color: "#333333"
            }
            Rectangle {
                anchors.centerIn: parent
                width: 2
                height: parent.height - 6
                color: "#333333"
            }
        }
    }

    QGLGraphItems.Line {
        dataTransform: axes.dataTransform
        path: QuickGraphLib.Helpers.linspace(0, 10, 80).map(x => Qt.point(x, 3 + 1.5 * Math.sin(x)))
        strokeColor: "#bbbbbb"
        strokeWidth: 2
    }
    QGLGraphItems.LineSegment {
        dataTransform: axes.dataTransform
        point1: axes.editablePoint1
        point2: axes.editablePoint2
        strokeColor: axes.lineSegmentSelected ? "#d62728" : "#8c564b"
        strokeWidth: 4
    }
    QGLGraphItems.LineSegmentEditor {
        dataTransform: axes.dataTransform
        point1: axes.editablePoint1
        point2: axes.editablePoint2
        centerHandleDelegate: moveHandleDelegate
        handleMode: QGLGraphItems.LineSegmentEditor.EndpointsAndCenter
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
        strokeColor: "#1f77b4"
        strokeStyle: QQS.ShapePath.DashLine
        strokeWidth: 3
    }
    QGLGraphItems.LineSegment {
        capStyle: QQS.ShapePath.FlatCap
        dataTransform: axes.dataTransform
        point1: Qt.point(2, 3.5)
        point2: Qt.point(8, 3.5)
        strokeColor: "#2ca02c"
        strokeWidth: 8
    }
}
