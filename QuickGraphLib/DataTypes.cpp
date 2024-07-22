// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// QuickGraphLib contributors SPDX-License-Identifier: MIT

#include "DataTypes.hpp"

#include <QMetaType>
#include <QVariant>

/*!
   Returns the polygon as a QVariant
*/
QGLPolygonF::operator QVariant() const { return QVariant::fromValue(*this); }

/*!
   Returns the list as a QVariant
*/
QGLDoubleList::operator QVariant() const { return QVariant::fromValue(*this); }

void registerConvertions() {
    QMetaType::registerConverter<QGLPolygonF, QPolygonF>();
    QMetaType::registerConverter<QPolygonF, QGLPolygonF>();
    QMetaType::registerConverter<QGLDoubleList, QList<qreal>>();
    QMetaType::registerConverter<QList<qreal>, QGLDoubleList>();
}
