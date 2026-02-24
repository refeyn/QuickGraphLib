# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

import os
import pathlib
import shutil
import sys

import PySide6

# Fix for PYSIDE-3267 (for some reason the linux tests don't need a fixup)

if sys.platform == "win32":
    from_ = pathlib.Path(os.environ["QT_PATH"]) / "bin/Qt6QuickVectorImageHelpers.dll"
    print("Copying", from_, "to", PySide6.__path__[0])
    shutil.copy(from_, PySide6.__path__[0])
