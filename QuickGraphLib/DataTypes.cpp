// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// QuickGraphLib contributors SPDX-License-Identifier: MIT

#include "DataTypes.hpp"

#include <QMetaType>
#include <QVariant>

/*!
    \class QGLPolygonF
    \inmodule QuickGraphLib
    \inheaderfile QuickGraphLib

    \brief A subclass of QPolygonF with better QML compatibility.

    \reentrant

    \ingroup painting
    \ingroup shared

    The QGLPolygonF class is \l {Implicit Data Sharing}{implicitly shared}.

    \section1 Additional Python functionality

    There is an additional staticmethod \c {QGLPolygonF.fromNDArray} which will convert an Nx2 ndarray into a
    \l QGLPolygonF efficiently.

    \sa QPolygonF
*/

/*!
   Returns the polygon as a QVariant
*/
QGLPolygonF::operator QVariant() const { return QVariant::fromValue(*this); }

/*!
    \class QGLDoubleList
    \inmodule QuickGraphLib
    \inheaderfile QuickGraphLib

    \brief A subclass of QList<qreal> with better QML compatibility.

    \reentrant

    \ingroup shared

    The QGLDoubleList class is \l {Implicit Data Sharing}{implicitly shared}.

    \section1 Additional Python functionality

    There is an additional staticmethod \c {QGLDoubleList.fromNDArray} which will convert a 1D ndarray into a
    \l QGLDoubleList efficiently.

    \sa QList
*/

/*!
   \fn QGLDoubleList::operator QVariant() const
   Returns the list as a QVariant
*/
QGLDoubleList::operator QVariant() const { return QVariant::fromValue(*this); }

void registerConvertions() {
    QMetaType::registerConverter<QGLPolygonF, QPolygonF>();
    QMetaType::registerConverter<QPolygonF, QGLPolygonF>();
    QMetaType::registerConverter<QGLDoubleList, QList<qreal>>();
    QMetaType::registerConverter<QList<qreal>, QGLDoubleList>();
}
