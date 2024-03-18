#pragma once

#include <QObject>
#include <QQmlEngine>

class Helpers : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
public:
    Q_INVOKABLE QList<qreal> linspace(qreal min, qreal max, int num) const;
    Q_INVOKABLE QList<int> range(int min, int max, int step = 1) const;
    Q_INVOKABLE QList<qreal> tickLocator(qreal min, qreal max, int maxNum) const;
};
