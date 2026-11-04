# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

from PySide6 import QtCore

import QuickGraphLib


def test_tick_locator() -> None:
    assert list(QuickGraphLib.Helpers.tickLocator(0, 100, 11)) == list(
        range(0, 110, 10)
    )
    assert list(QuickGraphLib.Helpers.tickLocator(0, 100, 5)) == list(range(0, 110, 25))


def test_decimal_points() -> None:
    assert (
        QuickGraphLib.Helpers.displayDecimalPoints(
            QtCore.QRectF(0, 0, 100, 0), QtCore.Qt.Orientation.Horizontal, [0, 10, 100]
        )
        == 0
    )
    assert (
        QuickGraphLib.Helpers.displayDecimalPoints(
            QtCore.QRectF(0, 0, 100, 0), QtCore.Qt.Orientation.Horizontal, [0, 0.5, 100]
        )
        == 1
    )
    assert (
        QuickGraphLib.Helpers.displayDecimalPoints(
            QtCore.QRectF(0, 0, 100, 0),
            QtCore.Qt.Orientation.Horizontal,
            [0, 0.05, 100],
        )
        == 2
    )
    assert (
        QuickGraphLib.Helpers.displayDecimalPoints(
            QtCore.QRectF(0, 0, 10, 0),
            QtCore.Qt.Orientation.Horizontal,
            [0, 100],
        )
        == 1
    )
    assert (
        QuickGraphLib.Helpers.displayDecimalPoints(
            QtCore.QRectF(0, 0, 1, 0),
            QtCore.Qt.Orientation.Horizontal,
            [x / 100 for x in range(101)],
        )
        == 3
    )
    assert (
        QuickGraphLib.Helpers.displayDecimalPoints(
            QtCore.QRectF(0, 0, 0, 0),
            QtCore.Qt.Orientation.Horizontal,
            [0, 0],
        )
        == 0
    )
    assert (
        QuickGraphLib.Helpers.displayDecimalPoints(
            QtCore.QRectF(0, 0, 0, 0),
            QtCore.Qt.Orientation.Horizontal,
            [],
        )
        == 0
    )
