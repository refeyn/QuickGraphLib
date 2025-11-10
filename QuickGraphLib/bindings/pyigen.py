# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

import contextlib
import os
import pathlib
import re
import sys
from typing import ContextManager

import PySide6.QtQuick
import PySide6.QtSvg
import shiboken6  # pylint: disable=unused-import
from shibokensupport.signature.lib import (  # type: ignore[import-not-found] # pylint: disable=import-error
    pyi_generator,
)

_dll_path = pathlib.Path(sys.argv[1].replace("bindings", "")).parent
os.environ["PATH"] = os.fspath(_dll_path) + os.pathsep + os.environ["PATH"]
if hasattr(os, "add_dll_directory"):
    cm: ContextManager = os.add_dll_directory(os.fspath(_dll_path))
else:
    cm = contextlib.nullcontext()
with cm:
    pyi_generator.PySide6 = PySide6
    pyi_generator.os = os
    pyi_generator.main()

# Fixup

path = (
    pathlib.Path(sys.argv[-1])
    / pathlib.Path(sys.argv[1]).with_suffix("").with_suffix(".pyi").name
)
text = (
    path.read_text(encoding="utf-8")
    .replace(
        "import _QuickGraphLib",
        "import QuickGraphLib._QuickGraphLib\nimport numpy",
    )
    .replace("collections.abc.Sequence[typing.Any]", "numpy.ndarray")
)
text = re.sub(r"'(.*,.*)'", r"typing.Union[\1]", text)
path.write_text(text, encoding="utf-8")
