// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QPolygonF>
#include <QQmlEngine>

#include "DataTypes.hpp"

struct QPolygonFRegistration {
    Q_GADGET
    QML_FOREIGN(QPolygonF)
    QML_ANONYMOUS
    QML_SEQUENTIAL_CONTAINER(QPointF)
};

class QGLPolygonFRegistration {
    Q_GADGET
    QML_FOREIGN(QGLPolygonF)
    QML_ANONYMOUS
    QML_SEQUENTIAL_CONTAINER(QPointF)
};

class QGLDoubleListRegistration {
    Q_GADGET
    QML_FOREIGN(QGLDoubleList)
    QML_ANONYMOUS
    QML_SEQUENTIAL_CONTAINER(qreal)
};
