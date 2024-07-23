# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

import os
import pathlib

from PySide6 import QtCore, QtGui, QtQml

from ._version import __version__, __version_tuple__

QML_IMPORT_PATH = str(pathlib.Path(__file__).parent.parent)

_dll_path = pathlib.Path(__file__).parent
os.environ["PATH"] = os.fspath(_dll_path) + os.pathsep + os.environ["PATH"]
with os.add_dll_directory(os.fspath(_dll_path)):
    from QuickGraphLib._QuickGraphLib import (  # pylint: disable=import-error,no-name-in-module
        QGLDoubleList,
        QGLPolygonF,
    )

from . import contours
