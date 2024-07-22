# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

import os
import pathlib

from PySide6 import QtCore, QtGui, QtQml

# from . import contours

QML_IMPORT_PATH = str(pathlib.Path(__file__).parent.parent)

_dll_path = pathlib.Path(__file__).parent
os.environ["PATH"] = os.fspath(_dll_path) + os.pathsep + os.environ["PATH"]
with os.add_dll_directory(os.fspath(_dll_path)):
    from ._QuickGraphLib import (  # type: ignore[import-not-found] # pylint: disable=import-error
        QGLDoubleList,
        QGLPolygonF,
    )
