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

QT_PATH = pathlib.Path(os.environ.get("Qt6_DIR", "C:/Qt/6.5.3/msvc2019_64"))
QT_VERSION = QT_PATH.parts[-2]
QDOC_PATH = QT_PATH / "bin/qdoc.exe"
INDEX_PATH = QT_PATH.parent.parent / ("Docs/Qt-" + QT_VERSION)
QDOCCONF_PATH = pathlib.Path(__file__).parent / "config.qdocconf"
QT_INSTALL_DOCS = QT_PATH / "doc"

for path in [QT_PATH, QDOC_PATH, INDEX_PATH, QDOCCONF_PATH, QT_INSTALL_DOCS]:
    if not path.exists():
        raise RuntimeError(f"Path {path} does not exist")

print("Using Qt", QT_VERSION, "from", QT_PATH)

proc = subprocess.run(
    [QDOC_PATH, QDOCCONF_PATH, "-indexdir", INDEX_PATH],
    env=collections.ChainMap({"QT_INSTALL_DOCS": str(QT_INSTALL_DOCS)}, os.environ),
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    check=False,
)
for line in proc.stdout.decode().split("\n"):
    if all(ignore not in line for ignore in IGNORED_LINES):
        print(line)
if proc.returncode != 0:
    print("Docs building failed")
