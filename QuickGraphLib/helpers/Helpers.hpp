// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QObject>
#include <QPicture>
#include <QQmlEngine>
#include <QQuickItem>

class Helpers : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
   public:
    Q_INVOKABLE QList<qreal> linspace(qreal min, qreal max, int num) const;
    Q_INVOKABLE QList<int> range(int min, int max, int step = 1) const;
    Q_INVOKABLE QList<qreal> tickLocator(qreal min, qreal max, int maxNum) const;
    Q_INVOKABLE QPolygonF mapPoints(QVariant points, QMatrix4x4 dataTransform) const;
    Q_INVOKABLE bool exportToSvg(QQuickItem* item, QUrl path) const;
    Q_INVOKABLE bool exportToPng(QQuickItem* item, QUrl path, int dpi = 96 * 2) const;
    Q_INVOKABLE QPicture exportToPicture(QQuickItem* item) const;
};
