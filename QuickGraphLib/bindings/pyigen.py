# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

import os
import pathlib
import sys

import PySide6.QtGui
import shiboken6  # pylint: disable=unused-import
from shibokensupport.signature.lib import (  # type: ignore[import-not-found] # pylint: disable=import-error
    pyi_generator,
)

_dll_path = pathlib.Path(sys.argv[1]).parent
os.environ["PATH"] = os.fspath(_dll_path) + os.pathsep + os.environ["PATH"]
with os.add_dll_directory(os.fspath(_dll_path)):
    pyi_generator.PySide6 = PySide6
    pyi_generator.main()

# Fixup

path = pathlib.Path(sys.argv[-1]) / pathlib.Path(sys.argv[1]).with_suffix(".pyi").name
path.write_text(
    path.read_text(encoding="utf-8")
    .replace(
        "import _QuickGraphLib", "import QuickGraphLib._QuickGraphLib\nimport numpy"
    )
    .replace("shibokensupport.signature.mapping.ArrayLikeVariable", "numpy.ndarray"),
    encoding="utf-8",
)
