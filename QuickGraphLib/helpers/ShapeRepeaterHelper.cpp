// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#include "ShapeRepeaterHelper.hpp"

// We are manipulating Shape.data, which only implements (directly) append, count, at and clear

Q_INVOKABLE void ShapeRepeaterHelper::insertObject(QQuickItem* graphArea, QObject* repeater, QObject* obj, int index) {
    auto data = QQmlListReference(graphArea, "data");
    auto count = data.count();
    std::vector<QPointer<QObject>> objs;

    qsizetype addAtIndex = -1;
    bool added = false;
    for (auto i = 0; i < count; ++i) {
        auto objAtI = data.at(i);
        if (objAtI == repeater) {
            addAtIndex = i + index;
        }
        objs.push_back(objAtI);
        if (i == addAtIndex) {
            objs.push_back(obj);
            added = true;
        }
    }
    if (!added) {
        objs.push_back(obj);
    }

    if (objs.back() == obj) {
        // Fast path
        data.append(obj);
        return;
    }

    data.clear();  // Scary things may happen

    for (auto& obj_ : objs) {
        if (!obj_.isNull()) {
            data.append(obj_);
        }
    }
}

Q_INVOKABLE void ShapeRepeaterHelper::removeObject(QQuickItem* graphArea, QObject* obj) {
    auto data = QQmlListReference(graphArea, "data");
    auto count = data.count();
    std::vector<QPointer<QObject>> objs;

    bool found = false;
    for (auto i = 0; i < count; ++i) {
        auto objAtI = data.at(i);
        if (objAtI == obj) {
            found = true;
        }
        else {
            objs.push_back(objAtI);
        }
    }

    if (!found) {
        return;
    }

    data.clear();  // Scary things may happen

    for (auto& obj_ : objs) {
        if (!obj_.isNull()) {
            data.append(obj_);
        }
    }
}
