import QtQuick
import QtQuick.Layouts as QQL
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.GraphItems as QGLGraphItems

QuickGraphLib.AntialiasingContainer {
    QQL.GridLayout {
        anchors.fill: parent
        anchors.margins: 20
        columnSpacing: 0
        columns: 3
        rowSpacing: 0

        Item {
        }
        QuickGraphLib.Axis {
            QQL.Layout.fillWidth: true
            dataTransform: grapharea.dataTransform
            decimalPoints: 0
            direction: QuickGraphLib.Axis.Direction.Top
            label: "Also angle (°)"
            ticks: QuickGraphLib.Helpers.linspace(0, 720, 9)
        }
        Item {
        }
        QuickGraphLib.Axis {
            id: yAxis

            QQL.Layout.fillHeight: true
            dataTransform: grapharea.dataTransform
            direction: QuickGraphLib.Axis.Direction.Left
            label: "Value"
            ticks: QuickGraphLib.Helpers.linspace(-1.0, 1.0, 11)
        }
        QuickGraphLib.GraphArea {
            id: grapharea

            QQL.Layout.fillHeight: true
            QQL.Layout.fillWidth: true
            viewRect: Qt.rect(-20, -1.1, 760, 2.2)

            QGLGraphItems.Grid {
                dataTransform: grapharea.dataTransform
                parentHeight: grapharea.height
                parentWidth: grapharea.width
                strokeColor: "#11000000"
                strokeWidth: 1
                xTicks: xAxis.ticks
                yTicks: yAxis.ticks
            }
            QGLGraphItems.Line {
                id: sinLine

                dataTransform: grapharea.dataTransform
                path: QuickGraphLib.Helpers.linspace(0, 720, 100).map(x => Qt.point(x, Math.sin(x / 180 * Math.PI)))
                strokeColor: "red"
                strokeWidth: 2
            }
            QGLGraphItems.BasicLegend {
                anchors.margins: 10
                anchors.right: parent.right
                anchors.top: parent.top

                QGLGraphItems.BasicLegendItem {
                    strokeColor: sinLine.strokeColor
                    text: "Sin(θ)"
                }
            }
        }
        QuickGraphLib.Axis {
            QQL.Layout.fillHeight: true
            dataTransform: grapharea.dataTransform
            direction: QuickGraphLib.Axis.Direction.Right
            label: "Also value"
            ticks: QuickGraphLib.Helpers.linspace(-1.0, 1.0, 11)
        }
        Item {
        }
        QuickGraphLib.Axis {
            id: xAxis

            QQL.Layout.fillWidth: true
            dataTransform: grapharea.dataTransform
            decimalPoints: 0
            direction: QuickGraphLib.Axis.Direction.Bottom
            label: "Angle (°)"
            ticks: QuickGraphLib.Helpers.linspace(0, 720, 9)
        }
        Item {
        }
    }
}
