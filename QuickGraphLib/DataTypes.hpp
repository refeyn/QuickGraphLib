// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QList>
#include <QPolygonF>

#include "Global.hpp"

class QGL_EXPORT QGLPolygonF : public QPolygonF {
   public:
    using QPolygonF::QPolygonF;
    QGLPolygonF() = default;
    QGLPolygonF(const QList<QPointF> &v) : QPolygonF(v) {}
    QGLPolygonF(const QPolygonF &v) : QPolygonF(v) {}
    QGLPolygonF(QList<QPointF> &&v) noexcept : QPolygonF(std::move(v)) {}
    QGLPolygonF(QPolygonF &&v) noexcept : QPolygonF(std::move(v)) {}
    inline void swap(QGLPolygonF &other) { QPolygonF::swap(other); }
    operator QVariant() const;
};
Q_DECLARE_SHARED(QGLPolygonF)

class QGL_EXPORT QGLDoubleList : public QList<qreal> {
   public:
    using QList<qreal>::QList;
    QGLDoubleList() = default;
    QGLDoubleList(const QList<qreal> &v) : QList<qreal>(v) {}
    QGLDoubleList(QList<qreal> &&v) noexcept : QList<qreal>(std::move(v)) {}
    inline void swap(QGLDoubleList &other) { QList<qreal>::swap(other); }
    operator QVariant() const;
};
Q_DECLARE_SHARED(QGLDoubleList)

QGL_EXPORT void registerConvertions();
