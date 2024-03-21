// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#include "GridHelper.hpp"

GridHelper::GridHelper(QObject *parent) : QObject{parent} {
    pathsProp.setBinding([&]() -> QList<QPolygonF> {
        auto xTicks = xTicksProp.value();
        auto yTicks = yTicksProp.value();
        auto viewRect = viewRectProp.value();
        auto dataTransform = dataTransformProp.value();
        QList<QPolygonF> paths;
        paths.reserve(xTicks.size() + yTicks.size());
        for (auto x : xTicks) {
            paths.emplaceBack(QList{
                dataTransform.map(QPointF{x, viewRect.y()}),
                dataTransform.map(QPointF{x, viewRect.y() + viewRect.height()})
            });
        }
        for (auto y : yTicks) {
            paths.emplaceBack(QList{
                dataTransform.map(QPointF{viewRect.x(), y}),
                dataTransform.map(QPointF{viewRect.x() + viewRect.width(), y})
            });
        }
        return paths;
    });
}
