// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QAbstractListModel>
#include <QBindable>
#include <QObject>
#include <QQmlEngine>
#include <QtGui/QMatrix4x4>
#include <QtGui/QPolygonF>

class AxisTickModel : public QAbstractListModel {
    Q_OBJECT
    QML_ELEMENT

    struct TickData {
        QPointF position;
        qreal value;
    };
    QList<TickData> _ticks;
    void _setTicks(QList<TickData> &&ticks);
    friend class AxisHelper;

   public:
    enum Roles { PositionRole = Qt::UserRole, ValueRole };

    AxisTickModel(QObject *parent = nullptr);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
};

class AxisHelper : public QObject {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QList<qreal> ticks READ ticks WRITE setTicks NOTIFY ticksChanged BINDABLE bindableTicks REQUIRED)
    Q_PROPERTY(QMatrix4x4 dataTransform READ dataTransform WRITE setDataTransform NOTIFY dataTransformChanged BINDABLE
                   bindableDataTransform REQUIRED)
    Q_PROPERTY(int direction READ direction WRITE setDirection NOTIFY directionChanged BINDABLE bindableDirection
                   REQUIRED)
    Q_PROPERTY(qreal width READ width WRITE setWidth NOTIFY widthChanged BINDABLE bindableWidth REQUIRED)
    Q_PROPERTY(qreal height READ height WRITE setHeight NOTIFY heightChanged BINDABLE bindableHeight REQUIRED)
    Q_PROPERTY(qreal tickLength READ tickLength WRITE setTickLength NOTIFY tickLengthChanged BINDABLE bindableTickLength
    )

    Q_PROPERTY(QPolygonF path READ path NOTIFY pathChanged BINDABLE bindablePath)
    Q_PROPERTY(AxisTickModel *tickModel READ tickModel CONSTANT)

    QList<int> _cachedTickPositions;
    AxisTickModel *_tickModel;

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

    void setTickLength(qreal tickLength) { tickLengthProp = tickLength; }
    qreal tickLength() const { return tickLengthProp; }
    QBindable<qreal> bindableTickLength() { return &tickLengthProp; }

    QPolygonF path() const { return pathProp; }
    QBindable<QPolygonF> bindablePath() { return &pathProp; }

    AxisTickModel *tickModel() const { return _tickModel; }

   signals:
    void ticksChanged();
    void dataTransformChanged();
    void directionChanged();
    void widthChanged();
    void heightChanged();
    void tickLengthChanged();
    void pathChanged();

   private:
    Q_OBJECT_BINDABLE_PROPERTY(AxisHelper, QList<qreal>, ticksProp, &AxisHelper::ticksChanged)
    Q_OBJECT_BINDABLE_PROPERTY(AxisHelper, QMatrix4x4, dataTransformProp, &AxisHelper::dataTransformChanged)
    Q_OBJECT_BINDABLE_PROPERTY(AxisHelper, int, directionProp, &AxisHelper::directionChanged)
    Q_OBJECT_BINDABLE_PROPERTY(AxisHelper, qreal, widthProp, &AxisHelper::widthChanged)
    Q_OBJECT_BINDABLE_PROPERTY(AxisHelper, qreal, heightProp, &AxisHelper::heightChanged)
    Q_OBJECT_BINDABLE_PROPERTY(AxisHelper, qreal, tickLengthProp, &AxisHelper::tickLengthChanged)
    Q_OBJECT_BINDABLE_PROPERTY(AxisHelper, QPolygonF, pathProp, &AxisHelper::pathChanged)
};
