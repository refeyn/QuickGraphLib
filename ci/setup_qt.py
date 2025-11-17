# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

import subprocess
import sys

if sys.platform == "linux":
    qt_platform = "linux"
    qt_arch = "linux_gcc_64"

elif sys.platform == "win32":
    qt_platform = "windows"
    qt_arch = "win64_msvc2022_64"

elif sys.platform == "darwin":
    qt_platform = "mac"
    qt_arch = "clang_64"

else:
    raise RuntimeError(f"Unknown platform {sys.platform}")

if sys.platform == "linux":
    prefix = "/opt/python/cp312-cp312/bin/"
else:
    prefix = ""

subprocess.run(
    [
        f"{prefix}pip",
        "install",
        "aqtinstall==3.3.*",
    ],
    check=True,
)
subprocess.run(
    [
        f"{prefix}python",
        "-m",
        "aqt",
        "install-qt",
        qt_platform,
        "desktop",
        "6.10.0",
        qt_arch,
        "-O",
        "./qt",
        "--archives",
        "qttools",
        "qtdeclarative",
        "qtbase",
        "qtsvg",
        "icu",
    ],
    check=True,
)

if sys.platform == "linux":
    subprocess.run(
        ["dnf", "install", "-y", "libxslt", "llvm-devel", "clang-libs", "libxkbcommon"],
        check=True,
    )
