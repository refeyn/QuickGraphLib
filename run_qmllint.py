# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

import itertools
import pathlib
import re
import subprocess
from typing import Literal, Optional

import pydantic

IGNORED_WARNINGS = [
    r"Ambiguous type detected. .*Dialog.* 6.0 is defined multiple times.",
    r'Warnings occurred while importing module "QtQuick.Dialogs":',
    r"Could not compile binding for .*: Member .* can be shadowed",
]
CHECK_PATHS = [
    pathlib.Path("QuickGraphLib").resolve(),
    pathlib.Path("examples").resolve(),
]
QML_FILES = list(
    itertools.chain.from_iterable(path.rglob("*.qml") for path in CHECK_PATHS)
)


class QMLLintError(pydantic.BaseModel):
    charOffset: Optional[int] = None
    column: Optional[int] = None
    id: str
    length: Optional[int] = None
    line: Optional[int] = None
    message: str
    suggestions: list[str]
    type: str


class QMLLintFile(pydantic.BaseModel):
    filename: pathlib.Path
    success: bool
    warnings: list[QMLLintError]


class QMLLintOutput(pydantic.BaseModel):
    files: list[QMLLintFile]
    revision: Literal[3]


try:
    out = subprocess.check_output(
        [
            "pyside6-qmllint",
            *QML_FILES,
            "-I",
            "stubs",
            "-I",
            "build",
            "--json",
            "-",
            "--compiler",
            "info",
        ]
    )
except subprocess.CalledProcessError as e:
    out = e.output

parsed = QMLLintOutput.model_validate_json(out)

warnings = 0
files_with_warnings = 0
for file in parsed.files:
    if len(file.warnings) > 0:
        files_with_warnings += 1
    for warning in file.warnings:
        if any(re.match(pattern, warning.message) for pattern in IGNORED_WARNINGS):
            continue
        warnings += warning.type == "warning"
        fname = file.filename
        for path in CHECK_PATHS:
            if path in file.filename.parents:
                fname = file.filename.relative_to(path.parent)
                break
        print(
            f"{fname}:{warning.line}: {warning.type}: {warning.message}  [{warning.id}]"
        )
print(
    f"Found {warnings} warnings in {files_with_warnings} files (checked {len(QML_FILES)} source files)"
)
