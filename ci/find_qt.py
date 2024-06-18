# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

import pathlib

for pth in pathlib.Path("qt").glob("[0-9]*/*"):
    if (pth / "bin").is_dir():
        print(pth.resolve().as_posix())

# Must not return an error code, as this gets run before all commands, including setup.py
