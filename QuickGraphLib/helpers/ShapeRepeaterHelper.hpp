// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QQuickItem>

class ShapeRepeaterHelper : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
   public:
    Q_INVOKABLE static void insertObject(QQuickItem* graphArea, QObject* repeater, QObject* obj, int index);
    Q_INVOKABLE static void removeObject(QQuickItem* graphArea, QObject* obj);
};
