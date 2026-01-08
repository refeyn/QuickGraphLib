# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

import contextlib
import os
import pathlib
from typing import ContextManager

from PySide6 import QtCore, QtGui, QtQml, QtQuick, QtSvg

from ._version import __version__, __version_tuple__

QML_IMPORT_PATH = str(pathlib.Path(__file__).parent.parent)

os.environ["QT_QUICKSHAPES_CHECK_ALL_CURVATURE"] = "1"

_dll_path = pathlib.Path(__file__).parent
if hasattr(os, "add_dll_directory"):
    cm: ContextManager = os.add_dll_directory(os.fspath(_dll_path))
else:
    cm = contextlib.nullcontext()
if os.name == "nt":
    os.environ["PATH"] = os.fspath(_dll_path) + os.pathsep + os.environ["PATH"]
with cm:
    from QuickGraphLib._QuickGraphLib import (  # pylint: disable=import-error,no-name-in-module
        Helpers,
        QGLDoubleList,
        QGLPolygonF,
    )

from . import contours
