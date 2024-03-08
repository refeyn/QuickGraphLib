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

proc = subprocess.run(
    [
        r"C:\Qt\6.5.1\msvc2019_64\bin\qdoc.exe",
        pathlib.Path(__file__).parent / "config.qdocconf",
        "-indexdir",
        r"C:\Qt\Docs\Qt-6.5.1",
    ],
    env=collections.ChainMap(
        {"QT_INSTALL_DOCS": r"C:\Qt\6.5.1\msvc2019_64\doc"}, os.environ
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
