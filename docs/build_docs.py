# SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

import collections
import os
import pathlib
import subprocess

IGNORED_LINES = [
    "Example has no project file",
    "Cannot find project file for example",
    "[Example directories:",
    "Unable to parse QML snippet:",
    "In file included from",
]

QT_PATH = pathlib.Path(os.environ.get("Qt6_DIR", "C:/Qt/6.5.1/msvc2019_64"))
QT_VERSION = QT_PATH.parts[-2]

print("Using Qt", QT_VERSION, "from", QT_PATH)

proc = subprocess.run(
    [
        QT_PATH / "bin/qdoc.exe",
        pathlib.Path(__file__).parent / "config.qdocconf",
        "-indexdir",
        QT_PATH.parent.parent / ("Docs/Qt-" + QT_VERSION),
    ],
    env=collections.ChainMap({"QT_INSTALL_DOCS": str(QT_PATH / "doc")}, os.environ),
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    check=False,
)
for line in proc.stdout.decode().split("\n"):
    if all(ignore not in line for ignore in IGNORED_LINES):
        print(line)
if proc.returncode != 0:
    print("Docs building failed")
