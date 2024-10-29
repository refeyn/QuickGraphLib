# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

import collections
import os
import pathlib
import subprocess
import sys

IGNORED_LINES = [
    "Example has no project file",
    "Cannot find project file for example",
    "[Example directories:",
    "Unable to parse QML snippet:",
    "In file included from",
]

QT_PATH = pathlib.Path(os.environ.get("QT_ROOT_DIR", "C:/Qt/6.8.0/msvc2022_64"))
QT_VERSION = QT_PATH.parts[-2]
QDOC_PATH = QT_PATH / "bin/qdoc.exe"
INDEX_PATH = QT_PATH.parent.parent / ("Docs/Qt-" + QT_VERSION)
QDOCCONF_PATH = pathlib.Path(__file__).parent / "config.qdocconf"
QT_INSTALL_DOCS = QT_PATH / "doc"
QT_INCLUDE_PATHS = [
    QT_PATH / "include",
    *(
        QT_PATH / "include" / module
        for module in ("QtCore", "QtGui", "QtQml", "QtQuick")
    ),
]

for path in [
    QT_PATH,
    QDOC_PATH,
    INDEX_PATH,
    QDOCCONF_PATH,
    QT_INSTALL_DOCS,
    *QT_INCLUDE_PATHS,
]:
    if not path.exists():
        raise RuntimeError(f"Path {path} does not exist")

print("Using Qt", QT_VERSION, "from", QT_PATH)

qgl_version = (
    subprocess.check_output([sys.executable, "-m", "setuptools_scm"]).decode().strip()
)

print("QGL version", qgl_version)

proc = subprocess.run(
    [
        QDOC_PATH,
        QDOCCONF_PATH,
        "-indexdir",
        INDEX_PATH,
        "-I",
        "QuickGraphLib",
        *(f"-I{path}" for path in QT_INCLUDE_PATHS),
    ],
    env=collections.ChainMap(
        {"QT_INSTALL_DOCS": str(QT_INSTALL_DOCS), "QGL_VERSION": qgl_version},
        os.environ,
    ),
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    check=False,
)
for line in proc.stdout.decode().split("\n"):
    if all(ignore not in line for ignore in IGNORED_LINES):
        print(line)
if proc.returncode != 0:
    print("Docs building failed")
