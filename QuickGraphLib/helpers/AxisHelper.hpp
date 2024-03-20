// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QBindable>
#include <QObject>
#include <QQmlEngine>
#include <QtGui/QMatrix4x4>
#include <QtGui/QPolygonF>

class AxisHelper : public QObject {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QList<qreal> ticks READ ticks WRITE setTicks NOTIFY ticksChanged BINDABLE bindableTicks REQUIRED)
    Q_PROPERTY(QMatrix4x4 dataTransform READ dataTransform WRITE setDataTransform NOTIFY dataTransformChanged BINDABLE
                   bindableDataTransform REQUIRED)
    Q_PROPERTY(
        int direction READ direction WRITE setDirection NOTIFY directionChanged BINDABLE bindableDirection REQUIRED)
    Q_PROPERTY(qreal width READ width WRITE setWidth NOTIFY widthChanged BINDABLE bindableWidth REQUIRED)
    Q_PROPERTY(qreal height READ height WRITE setHeight NOTIFY heightChanged BINDABLE bindableHeight REQUIRED)

    Q_PROPERTY(QPolygonF path READ path NOTIFY pathChanged BINDABLE bindablePath)
    Q_PROPERTY(
        QList<QPointF> tickPositions READ tickPositions NOTIFY tickPositionsChanged BINDABLE bindableTickPositions)

    QList<int> _cachedTickPositions;

   public:
    explicit AxisHelper(QObject *parent = nullptr);

    void setTicks(QList<qreal> ticks) { ticksProp = ticks; }
    QList<qreal> ticks() const { return ticksProp; }
    QBindable<QList<qreal>> bindableTicks() { return &ticksProp; }

    void setDataTransform(QMatrix4x4 dataTransform) { dataTransformProp = dataTransform; }
    QMatrix4x4 dataTransform() const { return dataTransformProp; }
    QBindable<QMatrix4x4> bindableDataTransform() { return &dataTransformProp; }

    void setDirection(int direction) { directionProp = direction; }
    int direction() const { return directionProp; }
    QBindable<int> bindableDirection() { return &directionProp; }

    void setWidth(qreal width) { widthProp = width; }
    int width() const { return widthProp; }
    QBindable<qreal> bindableWidth() { return &widthProp; }

    void setHeight(qreal height) { heightProp = height; }
    qreal height() const { return heightProp; }
    QBindable<qreal> bindableHeight() { return &heightProp; }

    QPolygonF path() const { return pathProp; }
    QBindable<QPolygonF> bindablePath() { return &pathProp; }

    QList<QPointF> tickPositions() const { return tickPositionsProp; }
    QBindable<QList<QPointF>> bindableTickPositions() { return &tickPositionsProp; }

   signals:
    void ticksChanged();
    void dataTransformChanged();
    void directionChanged();
    void widthChanged();
    void heightChanged();
    void pathChanged();
    void tickPositionsChanged();

   private:
    Q_OBJECT_BINDABLE_PROPERTY(AxisHelper, QList<qreal>, ticksProp, &AxisHelper::ticksChanged)
    Q_OBJECT_BINDABLE_PROPERTY(AxisHelper, QMatrix4x4, dataTransformProp, &AxisHelper::dataTransformChanged)
    Q_OBJECT_BINDABLE_PROPERTY(AxisHelper, int, directionProp, &AxisHelper::directionChanged)
    Q_OBJECT_BINDABLE_PROPERTY(AxisHelper, qreal, widthProp, &AxisHelper::widthChanged)
    Q_OBJECT_BINDABLE_PROPERTY(AxisHelper, qreal, heightProp, &AxisHelper::heightChanged)
    Q_OBJECT_BINDABLE_PROPERTY(AxisHelper, QPolygonF, pathProp, &AxisHelper::pathChanged)
    Q_OBJECT_BINDABLE_PROPERTY(AxisHelper, QList<QPointF>, tickPositionsProp, &AxisHelper::tickPositionsChanged)
};
