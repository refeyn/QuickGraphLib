# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

import contextlib
import os
import pathlib
from typing import ContextManager

from PySide6 import QtCore, QtGui, QtQml

from ._version import __version__, __version_tuple__

QML_IMPORT_PATH = str(pathlib.Path(__file__).parent.parent)

_dll_path = pathlib.Path(__file__).parent
os.environ["PATH"] = os.fspath(_dll_path) + os.pathsep + os.environ["PATH"]
if hasattr(os, "add_dll_directory"):
    cm: ContextManager = os.add_dll_directory(os.fspath(_dll_path))
else:
    cm = contextlib.nullcontext()
with cm:
    from QuickGraphLib._QuickGraphLib import (  # pylint: disable=import-error,no-name-in-module
        QGLDoubleList,
        QGLPolygonF,
    )

from . import contours
