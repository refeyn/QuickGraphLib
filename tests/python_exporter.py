# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

import contextlib
import pathlib
from typing import Any, Iterator

from PySide6 import QtCore, QtQml, QtQuick

import QuickGraphLib


@contextlib.contextmanager
def export(
    qml_component_path: pathlib.Path,
    properties: dict[str, Any],
    width: float = 800,
    height: float = 600,
) -> Iterator[QtQuick.QQuickItem]:
    incubation_controller = QtQml.QQmlIncubationController()

    engine = QtQml.QQmlEngine()
    engine.addImportPath(QuickGraphLib.QML_IMPORT_PATH)
    engine.setIncubationController(incubation_controller)

    component = QtQml.QQmlComponent(engine)
    incubator = QtQml.QQmlIncubator(QtQml.QQmlIncubator.IncubationMode.Asynchronous)
    incubator.setInitialProperties({"width": width, "height": height} | properties)

    component.loadUrl(
        QtCore.QUrl.fromLocalFile(qml_component_path),
        QtQml.QQmlComponent.CompilationMode.PreferSynchronous,
    )

    if component.status() == QtQml.QQmlComponent.Status.Error:
        raise RuntimeError(
            "Loading QML component failed: "
            + "\n".join(e.toString() for e in component.errors())
        )

    elif component.status() != QtQml.QQmlComponent.Status.Ready:
        raise RuntimeError("Bad component status")

    component.create(incubator)

    while incubator.status() not in {
        QtQml.QQmlIncubator.Status.Ready,
        QtQml.QQmlIncubator.Status.Error,
    }:
        incubation_controller.incubateFor(8)

    if incubator.status() == QtQml.QQmlIncubator.Status.Error:
        raise RuntimeError(
            "Creating QML component failed: "
            + "\n".join(e.toString() for e in incubator.errors())
        )
    elif incubator.status() != QtQml.QQmlIncubator.Status.Ready:
        raise RuntimeError("Bad incubator status")

    item = incubator.object()
    if not isinstance(item, QtQuick.QQuickItem):
        raise RuntimeError("Exporting QML component failed (not an Item)")

    # Bit of funkyness to make sure the items get polished (e.g. laid out properly)
    # which won't happen automatically if we use async incubation
    rendercontrol = QtQuick.QQuickRenderControl()
    window = QtQuick.QQuickWindow(rendercontrol)
    window.setRenderTarget(QtQuick.QQuickRenderTarget())
    window.resize(int(width), int(height))
    window.create()
    item.setParentItem(window.contentItem())
    rendercontrol.polishItems()

    yield item

    # Cleanup
    window.destroy()
    item.setParentItem(None)  # type: ignore[arg-type]
