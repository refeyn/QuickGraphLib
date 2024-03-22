// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QBindable>
#include <QObject>
#include <QQmlEngine>
#include <QtGui/QMatrix4x4>
#include <QtGui/QPolygonF>

class GridHelper : public QObject {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QList<qreal> xTicks READ xTicks WRITE setXTicks NOTIFY xTicksChanged BINDABLE bindableXTicks REQUIRED)
    Q_PROPERTY(QList<qreal> yTicks READ yTicks WRITE setYTicks NOTIFY yTicksChanged BINDABLE bindableYTicks REQUIRED)
    Q_PROPERTY(QRectF viewRect READ viewRect WRITE setViewRect NOTIFY viewRectChanged BINDABLE bindableViewRect REQUIRED
    )
    Q_PROPERTY(QMatrix4x4 dataTransform READ dataTransform WRITE setDataTransform NOTIFY dataTransformChanged BINDABLE
                   bindableDataTransform REQUIRED)
    Q_PROPERTY(QList<QPolygonF> paths READ paths NOTIFY pathsChanged BINDABLE bindablePaths)
   public:
    explicit GridHelper(QObject *parent = nullptr);

    void setXTicks(QList<qreal> xTicks) { xTicksProp = xTicks; }
    QList<qreal> xTicks() const { return xTicksProp; }
    QBindable<QList<qreal>> bindableXTicks() { return &xTicksProp; }

    void setYTicks(QList<qreal> yTicks) { yTicksProp = yTicks; }
    QList<qreal> yTicks() const { return yTicksProp; }
    QBindable<QList<qreal>> bindableYTicks() { return &yTicksProp; }

    void setViewRect(QRectF viewRect) { viewRectProp = viewRect; }
    QRectF viewRect() const { return viewRectProp; }
    QBindable<QRectF> bindableViewRect() { return &viewRectProp; }

    void setDataTransform(QMatrix4x4 dataTransform) { dataTransformProp = dataTransform; }
    QMatrix4x4 dataTransform() const { return dataTransformProp; }
    QBindable<QMatrix4x4> bindableDataTransform() { return &dataTransformProp; }

    QList<QPolygonF> paths() const { return pathsProp; }
    QBindable<QList<QPolygonF>> bindablePaths() { return &pathsProp; }

   signals:
    void xTicksChanged();
    void yTicksChanged();
    void viewRectChanged();
    void dataTransformChanged();
    void pathsChanged();

   private:
    Q_OBJECT_BINDABLE_PROPERTY(GridHelper, QList<qreal>, xTicksProp, &GridHelper::xTicksChanged)
    Q_OBJECT_BINDABLE_PROPERTY(GridHelper, QList<qreal>, yTicksProp, &GridHelper::yTicksChanged)
    Q_OBJECT_BINDABLE_PROPERTY(GridHelper, QRectF, viewRectProp, &GridHelper::viewRectChanged)
    Q_OBJECT_BINDABLE_PROPERTY(GridHelper, QMatrix4x4, dataTransformProp, &GridHelper::dataTransformChanged)
    Q_OBJECT_BINDABLE_PROPERTY(GridHelper, QList<QPolygonF>, pathsProp, &GridHelper::pathsChanged)
};
