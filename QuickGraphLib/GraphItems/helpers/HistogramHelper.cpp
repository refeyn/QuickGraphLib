// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#include "HistogramHelper.hpp"

HistogramHelper::HistogramHelper(QObject *parent) : QObject{parent} {
    pathProp.setBinding([&]() -> QPolygonF {
        auto bins = binsProp.value();
        auto heights = heightsProp.value();
        auto dataTransform = dataTransformProp.value();
        auto vertical = verticalProp.value();
        if (bins.size() < 1) {
            return {};
        }
        QPolygonF points;
        points.reserve(heights.size() * 2);
        // Bins must have at least one element due to the check above
        auto binIter = bins.begin();
        if (vertical) {
            points.emplaceBack(dataTransform.map(QPointF{0, *binIter}));
            for (auto h : heights) {
                points.emplaceBack(dataTransform.map(QPointF{h, *binIter}));
                if (++binIter == bins.end()) {
                    // bins.size() != heights.size() + 1, bail out
                    return points;
                }
                points.emplaceBack(dataTransform.map(QPointF{h, *binIter}));
            }
            points.emplaceBack(dataTransform.map(QPointF{0, *binIter}));
        }
        else {
            points.emplaceBack(dataTransform.map(QPointF{*binIter, 0}));
            for (auto h : heights) {
                points.emplaceBack(dataTransform.map(QPointF{*binIter, h}));
                if (++binIter == bins.end()) {
                    // bins.size() != heights.size() + 1, bail out
                    return points;
                }
                points.emplaceBack(dataTransform.map(QPointF{*binIter, h}));
            }
            points.emplaceBack(dataTransform.map(QPointF{*binIter, 0}));
        }
        return points;
    });
}
