// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QMatrix4x4>
#include <QObject>
#include <QPicture>
#include <QQmlEngine>
#include <QQuickItem>

#include "../Global.hpp"

class QGL_EXPORT Helpers : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
   public:
    Q_INVOKABLE static QList<qreal> linspace(qreal min, qreal max, int num);
    Q_INVOKABLE static QList<qreal> logspace(qreal logmin, qreal logmax, int num, qreal base = 10);
    Q_INVOKABLE static QList<int> range(int min, int max, int step = 1);
    Q_INVOKABLE static QList<qreal> tickLocator(qreal min, qreal max, int maxNum);
    Q_INVOKABLE static QPolygonF mapPoints(QVariant points, QMatrix4x4 dataTransform);
    Q_INVOKABLE static bool exportToSvg(QQuickItem* item, QUrl path);
    Q_INVOKABLE static bool exportToPng(QQuickItem* item, QUrl path, int dpi = 96 * 2);
    Q_INVOKABLE static QPicture exportToPicture(QQuickItem* item);
};
