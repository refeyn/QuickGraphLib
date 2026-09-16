# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

from PySide6 import QtCore, QtGui
import pytest

import QuickGraphLib


def polygon(points: list[tuple[float, float]]) -> QtGui.QPolygonF:
    return QtGui.QPolygonF([QtCore.QPointF(x, y) for x, y in points])


def test_distance_to_segment_projects_to_nearest_point() -> None:
    assert QuickGraphLib.Helpers.distanceToSegment(
        QtCore.QPointF(5, 3),
        QtCore.QPointF(0, 0),
        QtCore.QPointF(10, 0),
    ) == pytest.approx(3)
    assert QuickGraphLib.Helpers.distanceToSegment(
        QtCore.QPointF(4, 5),
        QtCore.QPointF(1, 1),
        QtCore.QPointF(1, 1),
    ) == pytest.approx(5)


def test_is_near_segment_uses_half_hit_width() -> None:
    assert QuickGraphLib.Helpers.isNearSegment(
        QtCore.QPointF(5, 4),
        QtCore.QPointF(0, 0),
        QtCore.QPointF(10, 0),
        8,
    )
    assert not QuickGraphLib.Helpers.isNearSegment(
        QtCore.QPointF(5, 4.1),
        QtCore.QPointF(0, 0),
        QtCore.QPointF(10, 0),
        8,
    )


def test_is_near_polyline_checks_open_and_closed_segments() -> None:
    points = polygon([(0, 0), (10, 0), (10, 10)])

    assert QuickGraphLib.Helpers.isNearPolyline(QtCore.QPointF(5, 3), points, 8, False)
    assert not QuickGraphLib.Helpers.isNearPolyline(
        QtCore.QPointF(5, 5), points, 4, False
    )
    assert QuickGraphLib.Helpers.isNearPolyline(QtCore.QPointF(5, 5), points, 4, True)


def test_is_inside_polygon_uses_odd_even_fill() -> None:
    triangle = polygon([(1, 1), (5, 5), (9, 1)])

    assert QuickGraphLib.Helpers.isInsidePolygon(QtCore.QPointF(5, 3), triangle)
    assert not QuickGraphLib.Helpers.isInsidePolygon(QtCore.QPointF(5, 0.5), triangle)
    assert not QuickGraphLib.Helpers.isInsidePolygon(
        QtCore.QPointF(5, 3), polygon([(0, 0), (1, 1)])
    )


def test_bounding_rect_handles_empty_single_and_multiple_points() -> None:
    assert QuickGraphLib.Helpers.boundingRect(polygon([])) == QtCore.QRectF()
    assert QuickGraphLib.Helpers.boundingRect(polygon([(3, 7)])) == QtCore.QRectF(
        3, 7, 0, 0
    )
    assert QuickGraphLib.Helpers.boundingRect(
        polygon([(1, 1), (5, 5), (9, 1)])
    ) == QtCore.QRectF(1, 1, 8, 4)


def test_normalized_rect_makes_dimensions_non_negative() -> None:
    assert QuickGraphLib.Helpers.normalizedRect(
        QtCore.QRectF(2, 3, 6, 4)
    ) == QtCore.QRectF(2, 3, 6, 4)
    assert QuickGraphLib.Helpers.normalizedRect(
        QtCore.QRectF(8, 7, -6, -4)
    ) == QtCore.QRectF(2, 3, 6, 4)
    assert QuickGraphLib.Helpers.normalizedRect(
        QtCore.QRectF(2, 3, 0, 0)
    ) == QtCore.QRectF(2, 3, 0, 0)


@pytest.mark.parametrize(
    ("position", "anchor", "minimum_size", "signs", "expected"),
    [
        ((1, 1), (8, 6), (0, 0), (-1, -1), (1, 1, 7, 5)),
        ((9, 1), (2, 6), (0, 0), (1, -1), (2, 1, 7, 5)),
        ((1, 7), (8, 2), (0, 0), (-1, 1), (1, 2, 7, 5)),
        ((9, 7), (2, 2), (0, 0), (1, 1), (2, 2, 7, 5)),
        ((10, 10), (8, 6), (0.5, 0.25), (-1, -1), (7.5, 5.75, 0.5, 0.25)),
        ((0, 10), (2, 6), (0.5, 0.25), (1, -1), (2, 5.75, 0.5, 0.25)),
        ((10, 0), (8, 2), (0.5, 0.25), (-1, 1), (7.5, 2, 0.5, 0.25)),
        ((0, 0), (2, 2), (0.5, 0.25), (1, 1), (2, 2, 0.5, 0.25)),
        ((10, 10), (8, 6), (-1, -1), (-1, -1), (8, 6, 0, 0)),
    ],
)
def test_clamped_resize_rect_preserves_direction_and_minimum_size(
    position: tuple[float, float],
    anchor: tuple[float, float],
    minimum_size: tuple[float, float],
    signs: tuple[int, int],
    expected: tuple[float, float, float, float],
) -> None:
    assert QuickGraphLib.Helpers.clampedResizeRect(
        QtCore.QPointF(*position),
        QtCore.QPointF(*anchor),
        *minimum_size,
        *signs,
    ) == QtCore.QRectF(*expected)


def test_is_inside_ellipse_rejects_invalid_radii() -> None:
    center = QtCore.QPointF(5, 4)

    assert QuickGraphLib.Helpers.isInsideEllipse(QtCore.QPointF(5, 4), center, 3, 2)
    assert QuickGraphLib.Helpers.isInsideEllipse(QtCore.QPointF(8, 4), center, 3, 2)
    assert not QuickGraphLib.Helpers.isInsideEllipse(
        QtCore.QPointF(8.1, 4), center, 3, 2
    )
    assert not QuickGraphLib.Helpers.isInsideEllipse(QtCore.QPointF(5, 4), center, 0, 2)
