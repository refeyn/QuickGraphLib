// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QObject>
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
    Q_INVOKABLE void exportToSvg(QQuickItem* item, QUrl path);
    Q_INVOKABLE void exportToPng(QQuickItem* item, QUrl path, int dpi = 96 * 2);
};
