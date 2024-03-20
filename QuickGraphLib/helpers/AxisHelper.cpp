// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other
// QuickGraphLib contributors SPDX-License-Identifier: MIT

#include "AxisHelper.hpp"

enum Direction { Left, Right, Top, Bottom };

AxisHelper::AxisHelper(QObject *parent) : QObject{parent} {
    pathProp.setBinding([&]() -> QPolygonF {
        auto direction = directionProp.value();
        auto width = widthProp.value();
        auto height = heightProp.value();
        auto ticks = ticksProp.value();
        auto dataTransform = dataTransformProp.value();
        auto tickLength = 0;

        auto longAxis = direction == Top || direction == Bottom ? width : height;

        // Calculate everything as if we were a bottom axis
        auto points = QList{QPointF{0, 0}};
        points.reserve(ticks.size() * 3 + 2);
        QList<int> tickPositions;
        tickPositions.reserve(ticks.size());
        for (auto tick : ticks) {
            auto t = direction == Top || direction == Bottom ? dataTransform.map(QPointF{tick, 0}).x()
                                                             : dataTransform.map(QPointF{0, tick}).y();
            if (t >= -0.5 && t <= longAxis + 0.5) {
                points.emplaceBack(t, 0);
                points.emplaceBack(t, tickLength);
                points.emplaceBack(t, 0);
                tickPositions.append(points.size() - 2);
            }
            else {
                tickPositions.append(-1);
            }
        }
        points.emplaceBack(longAxis, 0);

        // Transform into the correct positions
        switch (direction) {
            case Left: {
                for (auto &p : points) {
                    auto x = p.x();
                    p.setX(width - p.y());
                    p.setY(x);
                }
                break;
            }
            case Right: {
                for (auto &p : points) {
                    auto x = p.x();
                    p.setX(p.y());
                    p.setY(x);
                }
                break;
            }
            case Top: {
                for (auto &p : points) {
                    p.setY(height - p.y());
                }
                break;
            }
            case Bottom: {
                break;
            }
        }
        _cachedTickPositions = tickPositions;
        return points;
    });

    tickPositionsProp.setBinding([&]() -> QList<QPointF> {
        auto path = pathProp.value();
        QList<QPointF> tickPositions;
        tickPositions.reserve(_cachedTickPositions.size());
        for (auto index : _cachedTickPositions) {
            if (index == -1) {
                tickPositions.emplaceBack(-1, -1);
            }
            else {
                tickPositions.append(path[index]);
            }
        }
        return tickPositions;
    });
}
