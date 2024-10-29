# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

import pathlib
import sys

import numpy as np
import pytest
from PySide6 import QtCore, QtGui, QtQml, QtQuick, QtQuickControls2

import QuickGraphLib
from examples import conway  # pylint: disable=unused-import

EXAMPLE_PATHS = [
    path
    for path in (pathlib.Path(__file__).parent.parent / "examples").glob("*.qml")
    if path.name != "ExampleGallery.qml"
]
REFERENCE_PATH = pathlib.Path(__file__).parent / "reference_images"
FONT_PATH = pathlib.Path(__file__).parent / "fonts"
GENERATE_REFERENCE_IMAGES = False

# Getting the same results on different OSes is tricky, so essentially
# disable the comparisons when not on Windows (which is where the references were generated)
# TODO Improve this (have a reference set per OS?)
THRESHOLD = 0 if sys.platform == "win32" else 0.03

QML_IMPORT_NAME = "Tests"
QML_IMPORT_MAJOR_VERSION = 1


@pytest.fixture(scope="session")
def qapp() -> QtGui.QGuiApplication:
    QtQuick.QQuickWindow.setGraphicsApi(
        QtQuick.QSGRendererInterface.GraphicsApi.Software
    )
    QtQuick.QQuickWindow.setSceneGraphBackend("software")
    QtQuick.QQuickWindow.setTextRenderType(
        QtQuick.QQuickWindow.TextRenderType.QtTextRendering
    )

    QtQuickControls2.QQuickStyle.setStyle("Basic")

    app = QtGui.QGuiApplication(["", "-platform", "offscreen"])

    for fontPath in FONT_PATH.glob("*.ttf"):
        QtGui.QFontDatabase.addApplicationFont(str(fontPath))
    app.setFont(QtGui.QFont("DejaVuSans", 11, QtGui.QFont.Weight.Normal))

    return app


@QtQml.QmlElement
@QtQml.QmlSingleton
class PictureSaver(QtCore.QObject):
    @QtCore.Slot(QtGui.QPicture, QtCore.QUrl)
    def savePicture(self, picture: QtGui.QPicture, url: QtCore.QUrl) -> None:
        picture.save(url.toLocalFile())


def compare_images(a: pathlib.Path, b: pathlib.Path, width: int, height: int) -> float:
    a_img = QtGui.QImage(str(a))
    b_img = QtGui.QImage(str(b))
    assert a_img.width() == b_img.width() == width
    assert a_img.height() == b_img.height() == height
    shape = (height, width, 4)
    reference_arr = np.asarray(a_img.bits()).reshape(shape).astype(int)
    output_arr = np.asarray(b_img.bits()).reshape(shape).astype(int)
    difference = np.abs(reference_arr - output_arr).sum() / reference_arr.size / 255
    print(f"Difference of {a.name} is {difference:.4f}")
    return difference


@pytest.mark.parametrize("example_path", EXAMPLE_PATHS, ids=lambda p: str(p.stem))
def test_export(
    example_path: pathlib.Path, qapp: QtGui.QGuiApplication, tmp_path: pathlib.Path
) -> None:
    grab_path = tmp_path / f"{example_path.stem}_grab.png"
    png_path = tmp_path / f"{example_path.stem}.png"
    svg_path = tmp_path / f"{example_path.stem}.svg"
    picture_path = tmp_path / f"{example_path.stem}.dat"

    engine = QtQml.QQmlApplicationEngine()
    engine.setInitialProperties(
        {
            "exampleUrl": QtCore.QUrl.fromLocalFile(example_path),
            "outputGrabUrl": QtCore.QUrl.fromLocalFile(grab_path),
            "outputPngUrl": QtCore.QUrl.fromLocalFile(png_path),
            "outputSvgUrl": QtCore.QUrl.fromLocalFile(svg_path),
            "outputPictureUrl": QtCore.QUrl.fromLocalFile(picture_path),
        }
    )
    engine.addImportPath(QuickGraphLib.QML_IMPORT_PATH)
    engine.loadData(
        rb"""
import QtQuick
import QuickGraphLib as QuickGraphLib
import Tests as Tests
Window {
    id: root
    required property url exampleUrl

    required property url outputGrabUrl
    required property url outputPngUrl
    required property url outputSvgUrl
    required property url outputPictureUrl
    property bool hasExported: false

    width: 800
    height: 600
    visible: true
    Rectangle {
        id: content
        color: "white"
        anchors.fill: parent
        border.width: 0

        Loader {
            source: exampleUrl
            anchors.fill: parent
        }
    }
    onFrameSwapped: {
        if (root.hasExported) return;
        content.ensurePolished();
        let res = content.grabToImage(result => {
            result.saveToFile(root.outputGrabUrl);
            Qt.exit(0);
        });
        if (!res) {
            Qt.exit(1);
        }
        QuickGraphLib.Helpers.exportToPng(content, root.outputPngUrl);
        QuickGraphLib.Helpers.exportToSvg(content, root.outputSvgUrl);
        Tests.PictureSaver.savePicture(QuickGraphLib.Helpers.exportToPicture(content), root.outputPictureUrl);
        root.hasExported = true;
    }
}
"""
    )
    assert len(engine.rootObjects()) != 0
    engine.quit.connect(qapp.quit)
    assert qapp.exec() == 0

    if GENERATE_REFERENCE_IMAGES:
        for fname in [grab_path, png_path, svg_path, picture_path]:
            reference_path = REFERENCE_PATH / fname.name
            if reference_path.exists():
                reference_path.unlink()
            fname.rename(reference_path)

    else:
        assert (
            compare_images(grab_path, REFERENCE_PATH / grab_path.name, 800, 600)
            <= THRESHOLD
        )
        assert (
            compare_images(png_path, REFERENCE_PATH / png_path.name, 1600, 1200)
            <= THRESHOLD
        )
        # TODO SVG and QPicture comparisons
