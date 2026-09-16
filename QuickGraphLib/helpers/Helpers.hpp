// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QMatrix4x4>
#include <QObject>
#include <QPicture>
#include <QPointF>
#include <QPolygonF>
#include <QQmlEngine>
#include <QQuickItem>
#include <QRectF>
#include <QVariant>

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
    Q_INVOKABLE static QRectF boundingRect(QVariant points);
    Q_INVOKABLE static QRectF normalizedRect(QRectF rect);
    Q_INVOKABLE static QRectF clampedResizeRect(QPointF position, QPointF anchor, qreal minimumWidth,
                                                qreal minimumHeight, int xSign, int ySign);
    Q_INVOKABLE static qreal distanceToSegment(QPointF point, QPointF segmentStart, QPointF segmentEnd);
    Q_INVOKABLE static bool isNearSegment(QPointF point, QPointF segmentStart, QPointF segmentEnd, qreal hitWidth);
    Q_INVOKABLE static bool isNearPolyline(QPointF point, QVariant points, qreal hitWidth, bool closed);
    Q_INVOKABLE static bool isInsidePolygon(QPointF point, QVariant points);
    Q_INVOKABLE static bool isInsideEllipse(QPointF point, QPointF center, qreal radiusX, qreal radiusY);
    Q_INVOKABLE static bool exportToSvg(QQuickItem* item, QUrl path);
    Q_INVOKABLE static bool exportToPng(QQuickItem* item, QUrl path, int dpi = 96 * 2);
    Q_INVOKABLE static QPicture exportToPicture(QQuickItem* item);
};
