# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

import pathlib

import numpy as np
import pytest
from PySide6 import QtCore, QtGui, QtQml

import QuickGraphLib
from examples import conway

EXAMPLE_PATHS = [
    path
    for path in (pathlib.Path(__file__).parent.parent / "examples").glob("*.qml")
    if path.name != "ExampleGallery.qml"
]
REFERENCE_PATH = pathlib.Path(__file__).parent / "reference_images"
GENERATE_REFERENCE_IMAGES = False


@pytest.fixture(scope="session")
def qapp() -> QtGui.QGuiApplication:
    return QtGui.QGuiApplication([])


@pytest.mark.parametrize("example_path", EXAMPLE_PATHS, ids=lambda p: str(p.stem))
def test_export(
    example_path: pathlib.Path, qapp: QtGui.QGuiApplication, tmp_path: pathlib.Path
) -> None:
    image_path = tmp_path / f"{example_path.stem}.png"
    engine = QtQml.QQmlApplicationEngine()
    engine.setInitialProperties(
        {
            "exampleUrl": QtCore.QUrl.fromLocalFile(example_path),
            "outputUrl": QtCore.QUrl.fromLocalFile(image_path),
        }
    )
    engine.addImportPath(QuickGraphLib.QML_IMPORT_PATH)
    engine.loadData(
        rb"""
import QtQuick
Window {
    id: root
    required property url exampleUrl
    required property url outputUrl
    width: 800
    height: 600
    visible: true
    Loader {
        id: loader
        source: exampleUrl
        anchors.fill: parent
    }
    Component.onCompleted: {
        let res = loader.item.grabToImage(result => {
           result.saveToFile(root.outputUrl);
            Qt.exit(0);
        });
        if (!res) {
            Qt.exit(1);
        }
    }
}
"""
    )
    assert len(engine.rootObjects()) != 0
    engine.quit.connect(qapp.quit)
    assert qapp.exec() == 0

    reference_path = REFERENCE_PATH / image_path.name
    if GENERATE_REFERENCE_IMAGES:
        if reference_path.exists():
            reference_path.unlink()
        image_path.rename(reference_path)

    else:
        reference_img = QtGui.QImage(str(reference_path))
        output_img = QtGui.QImage(str(image_path))
        assert reference_img.width() == output_img.width() == 800
        assert reference_img.height() == output_img.height() == 600
        shape = (reference_img.height(), reference_img.width(), 4)
        reference_arr = np.asarray(reference_img.bits()).reshape(shape).astype(int)
        output_arr = np.asarray(output_img.bits()).reshape(shape).astype(int)
        difference = np.abs(reference_arr - output_arr).sum() / shape[0] / shape[1]
        print(difference)
        assert difference < 0.01
