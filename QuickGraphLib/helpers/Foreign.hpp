// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QPolygonF>
#include <QQmlEngine>

struct QPolygonFForeign {
    Q_GADGET
    QML_FOREIGN(QPolygonF)
    QML_ANONYMOUS
};
