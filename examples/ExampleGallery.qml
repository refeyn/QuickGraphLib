pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts as QQL
import QtQuick.Controls as QQC
import QtQuick.Dialogs as QQD
import QuickGraphLib as QuickGraphLib
import QuickGraphLib.PythonHelpers as QGLPyHelpers

QQC.ApplicationWindow {
    id: root

    required property var examples
    property var exportData: null
    property var selectedExample: null

    minimumHeight: 600
    minimumWidth: 800
    title: qsTr("QuickGraphLib example gallery")
    visible: true

    header: QQC.ToolBar {
        QQL.RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8

            QQC.ToolButton {
                id: backButton

                font.pixelSize: 24
                text: "⮜"
                visible: root.selectedExample !== null

                onClicked: root.selectedExample = null
            }
            Item {
                implicitWidth: exportPngButton.width + exportSvgButton.width - backButton.width
                visible: root.selectedExample !== null
            }
            QQC.Label {
                QQL.Layout.fillWidth: true
                font.bold: true
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
                text: root.selectedExample ? root.selectedExample[0] : "QuickGraphLib example gallery"
                verticalAlignment: Text.AlignVCenter
            }
            QQC.ToolButton {
                id: exportPngButton

                text: "Export\nPNG"
                visible: root.selectedExample !== null

                onClicked: {
                    root.exportData = QuickGraphLib.Helpers.exportData(graph);
                    pngDialog.open();
                }
            }
            QQC.ToolButton {
                id: exportSvgButton

                text: "Export\nSVG"
                visible: root.selectedExample !== null

                onClicked: {
                    root.exportData = QuickGraphLib.Helpers.exportData(graph);
                    svgDialog.open();
                }
            }
        }
    }

    QQD.FileDialog {
        id: svgDialog

        fileMode: QQD.FileDialog.SaveFile
        nameFilters: ["SVG files (*.svg)", "All files (*)"]
        title: "Export SVG"

        onAccepted: QGLPyHelpers.ExportHelper.exportToSvg(root.exportData, selectedFile)
    }
    QQD.FileDialog {
        id: pngDialog

        fileMode: QQD.FileDialog.SaveFile
        nameFilters: ["PNG files (*.png)", "All files (*)"]
        title: "Export PNG"

        onAccepted: QGLPyHelpers.ExportHelper.exportToPng(root.exportData, selectedFile)
    }
    Loader {
        id: graph

        anchors.fill: parent
        anchors.margins: 10
        source: root.selectedExample ? root.selectedExample[2] : ""
    }
    GridView {
        id: grid

        anchors.fill: parent
        anchors.topMargin: 8
        cellHeight: cellWidth
        cellWidth: Math.floor(width / 5)
        model: root.examples
        visible: root.selectedExample === null

        QQC.ScrollBar.vertical: QQC.ScrollBar {
        }
        delegate: Item {
            id: delegate

            required property var modelData

            height: grid.cellHeight
            width: grid.cellWidth

            MouseArea {
                id: mouseArea

                anchors.fill: parent
                hoverEnabled: true

                onClicked: root.selectedExample = delegate.modelData
            }
            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                border.color: "grey"
                border.width: 1
                color: mouseArea.containsMouse ? "#11000000" : "transparent"
            }
            QQL.ColumnLayout {
                anchors.fill: parent
                anchors.margins: 4
                spacing: 4

                Image {
                    QQL.Layout.fillHeight: true
                    QQL.Layout.fillWidth: true
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    source: delegate.modelData[1]
                }
                QQC.Label {
                    QQL.Layout.fillWidth: true
                    elide: Text.ElideMiddle
                    horizontalAlignment: Qt.AlignHCenter
                    text: delegate.modelData[0]
                }
            }
        }
    }
}
