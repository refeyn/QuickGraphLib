// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
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
            paths.emplaceBack(
                QList{dataTransform.map(QPointF{x, viewRect.top()}), dataTransform.map(QPointF{x, viewRect.bottom()})}
            );
        }
        for (auto y : yTicks) {
            paths.emplaceBack(
                QList{dataTransform.map(QPointF{viewRect.left(), y}), dataTransform.map(QPointF{viewRect.right(), y})}
            );
        }
        return paths;
    });
}
