# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

import enum
import itertools
import pathlib
import re

import numpy as np
from PySide6 import QtCore, QtQml

from QuickGraphLib import QGLDoubleList

QML_IMPORT_NAME = "examples.Conway"
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0


@QtQml.QmlElement
class ConwayProvider(QtCore.QObject):
    class CellTransition(enum.IntFlag):
        SURVIVE = 1
        BORN = 2
        DIE = 0
        BORN_AND_SURVIVE = SURVIVE | BORN

    RULE_LENGTH = 9
    FILE_LOAD_PADDING = 2

    def __init__(self):
        super().__init__()

        self._buffer = np.zeros((100, 100), dtype=bool)
        self._history_buffer = np.zeros_like(self._buffer, dtype=int)
        self._neighbour_counts = np.zeros_like(self._buffer, dtype=int)
        # Standard game is B3/S23
        self._rule = self._rule_from_strs("3", "23")

    sizeChanged = QtCore.Signal(name="sizeChanged")

    @QtCore.Property(QtCore.QSize, notify=sizeChanged)
    def size(self) -> QtCore.QSize:
        return QtCore.QSize(*self._buffer.shape[::-1])

    @size.setter  # type: ignore[no-redef]
    def size(self, size: QtCore.QSize) -> None:
        left_y = max(0, round((size.height() - self._buffer.shape[0]) / 2))
        right_y = max(0, round((self._buffer.shape[0] - size.height()) / 2))
        min_height = min(self._buffer.shape[0], size.height())

        left_x = max(0, round((size.width() - self._buffer.shape[1]) / 2))
        right_x = max(0, round((self._buffer.shape[1] - size.width()) / 2))
        min_width = min(self._buffer.shape[1], size.width())

        new_buffer = np.zeros((size.height(), size.width()), dtype=bool)
        new_buffer[left_y : left_y + min_height, left_x : left_x + min_width] = (
            self._buffer[right_y : right_y + min_height, right_x : right_x + min_width]
        )
        self._buffer = new_buffer

        new_history_buffer = np.zeros((size.height(), size.width()), dtype=int)
        new_history_buffer[
            left_y : left_y + min_height, left_x : left_x + min_width
        ] = self._history_buffer[
            right_y : right_y + min_height, right_x : right_x + min_width
        ]
        self._history_buffer = new_history_buffer

        new_neighbour_counts = np.zeros((size.height(), size.width()), dtype=int)
        new_neighbour_counts[
            left_y : left_y + min_height, left_x : left_x + min_width
        ] = self._neighbour_counts[
            right_y : right_y + min_height, right_x : right_x + min_width
        ]
        self._neighbour_counts = new_neighbour_counts

        self.sizeChanged.emit()
        self.dataChanged.emit()

    ruleChanged = QtCore.Signal(name="ruleChanged")

    @QtCore.Property(str, notify=ruleChanged)
    def ruleB(self) -> str:
        return self._strs_from_rule()[0]

    @ruleB.setter  # type: ignore[no-redef]
    def ruleB(self, rule_b: str) -> None:
        self._rule = self._rule_from_strs(rule_b, self._strs_from_rule()[1])
        self.ruleChanged.emit()

    @QtCore.Property(str, notify=ruleChanged)
    def ruleS(self) -> str:
        return self._strs_from_rule()[1]

    @ruleS.setter  # type: ignore[no-redef]
    def ruleS(self, rule_s: str) -> None:
        self._rule = self._rule_from_strs(self._strs_from_rule()[0], rule_s)
        self.ruleChanged.emit()

    dataChanged = QtCore.Signal(name="dataChanged")

    @QtCore.Property(QGLDoubleList, notify=dataChanged)  # type: ignore[operator, arg-type]
    def cells(self) -> QGLDoubleList:
        return QGLDoubleList.fromNDArray(self._buffer.ravel().astype(int))

    @QtCore.Property(QGLDoubleList, notify=dataChanged)  # type: ignore[operator, arg-type]
    def historyCells(self) -> QGLDoubleList:
        return QGLDoubleList.fromNDArray(self._history_buffer.ravel())

    @QtCore.Property(QGLDoubleList, notify=dataChanged)  # type: ignore[operator, arg-type]
    def neighbourCounts(self) -> QGLDoubleList:
        return QGLDoubleList.fromNDArray(self._neighbour_counts.ravel())

    @QtCore.Slot()
    def tick(self) -> None:
        self._neighbour_counts = np.zeros(self._buffer.shape, dtype=int)
        for y_shift, x_shift in itertools.product([-1, 0, 1], repeat=2):
            if y_shift or x_shift:
                self._neighbour_counts += np.roll(
                    self._buffer, (y_shift, x_shift), (0, 1)
                )
        for i, rule in enumerate(self._rule):
            match rule:
                case self.CellTransition.BORN_AND_SURVIVE:
                    self._buffer[self._neighbour_counts == i] = True
                case self.CellTransition.BORN:
                    self._buffer[self._neighbour_counts == i] = ~self._buffer[
                        self._neighbour_counts == i
                    ]
                case self.CellTransition.SURVIVE:
                    pass
                case self.CellTransition.DIE:
                    self._buffer[self._neighbour_counts == i] = False
        self._history_buffer *= 95
        self._history_buffer //= 100
        self._history_buffer[self._buffer] = 1000
        self.dataChanged.emit()

    @QtCore.Slot()
    def reset(self) -> None:
        self._buffer = np.zeros((100, 100), dtype=bool)
        self._history_buffer = np.zeros_like(self._buffer, dtype=int)
        self._neighbour_counts = np.zeros_like(self._buffer, dtype=int)
        self.dataChanged.emit()
        self.sizeChanged.emit()

    @QtCore.Slot()
    def rot90(self) -> None:
        self._buffer = np.rot90(self._buffer)
        self._history_buffer = np.rot90(self._history_buffer)
        self._neighbour_counts = np.rot90(self._neighbour_counts)
        self.dataChanged.emit()
        self.sizeChanged.emit()

    def _rule_from_strs(self, rule_b: str, rule_s: str) -> list[CellTransition]:
        rule = [self.CellTransition.DIE] * self.RULE_LENGTH
        for num in rule_s:
            rule[int(num)] |= self.CellTransition.SURVIVE
        for num in rule_b:
            rule[int(num)] |= self.CellTransition.BORN
        return rule

    def _strs_from_rule(self) -> tuple[str, str]:
        rule_s = "".join(
            [
                str(i)
                for i in range(self.RULE_LENGTH)
                if self._rule[i] & self.CellTransition.SURVIVE
            ]
        )
        rule_b = "".join(
            [
                str(i)
                for i in range(self.RULE_LENGTH)
                if self._rule[i] & self.CellTransition.BORN
            ]
        )
        return rule_b, rule_s

    @QtCore.Slot(QtCore.QUrl)
    def loadFile(self, url: QtCore.QUrl) -> None:
        path = pathlib.Path(url.toLocalFile())
        if path.suffix != ".rle":
            print("Unrecognized file type")
            return

        data = path.read_text(encoding="ascii")
        seen_header = False
        initial_x = current_x = current_y = 0
        buffer = np.zeros((0, 0), dtype=bool)
        rule_b = rule_s = None
        for line in data.split("\n"):
            if line.startswith("#") or not line.strip():
                pass
            elif not seen_header:
                line_match = re.match(
                    r"\s*x\s*=\s*(\d+),\s*y\s*=\s*(\d+)(?:,\s*rule\s*=\s*B(\d*)/S(\d*))?",
                    line,
                )
                if not line_match:
                    print("Could not interpret file header")
                    return
                x, y, rule_b, rule_s = line_match.groups()

                x, y = int(x), int(y)
                buffer = np.zeros(
                    (
                        max(self._buffer.shape[0], y + self.FILE_LOAD_PADDING * 2),
                        max(self._buffer.shape[1], x + self.FILE_LOAD_PADDING * 2),
                    ),
                    dtype=bool,
                )
                initial_x = current_x = (buffer.shape[1] - x) // 2
                current_y = (buffer.shape[0] - y) // 2
                seen_header = True
            else:
                line = line.strip()
                while line and line != "!":
                    tag = re.match(r"(\d*)([a-zA-Z$])", line)
                    if not tag:
                        print("Could not interpret RLE sequence item")
                        return
                    times = int(tag.group(1) or "1")
                    op = tag.group(2) if tag.group(2) in "ob$" else "o"
                    for _ in range(times):
                        if op == "$":
                            current_y += 1
                            current_x = initial_x
                        else:
                            if op == "o":
                                buffer[(current_y, current_x)] = True
                            current_x += 1
                    line = line[tag.end() :].strip()

        self._buffer = buffer
        self._history_buffer = self._buffer.astype(int)
        self._neighbour_counts = np.zeros_like(self._buffer, dtype=int)
        self._rule = self._rule_from_strs(
            "3" if rule_b is None else rule_b, "23" if rule_s is None else rule_s
        )
        self.sizeChanged.emit()
        self.dataChanged.emit()
        self.ruleChanged.emit()
