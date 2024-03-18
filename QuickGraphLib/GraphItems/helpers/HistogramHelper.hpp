#pragma once

#include <QObject>
#include <QBindable>
#include <QQmlEngine>
#include <QtGui/QPolygonF>
#include <QtGui/QMatrix4x4>

class HistogramHelper : public QObject {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QList<qreal> heights READ heights WRITE setHeights NOTIFY heightsChanged BINDABLE bindableHeights REQUIRED)
    Q_PROPERTY(QList<qreal> bins READ bins WRITE setBins NOTIFY binsChanged BINDABLE bindableBins REQUIRED)
    Q_PROPERTY(QMatrix4x4 dataTransform READ dataTransform WRITE setDataTransform NOTIFY dataTransformChanged BINDABLE bindableDataTransform REQUIRED)
    Q_PROPERTY(bool vertical READ vertical WRITE setVertical NOTIFY verticalChanged BINDABLE bindableVertical REQUIRED)

    Q_PROPERTY(QPolygonF path READ path NOTIFY pathChanged BINDABLE bindablePath)
public:
    explicit HistogramHelper(QObject *parent = nullptr);

    void setHeights(QList<qreal> heights) { heightsProp = heights; }
    QList<qreal> heights() const { return heightsProp; }
    QBindable<QList<qreal>> bindableHeights() { return &heightsProp; }

    void setBins(QList<qreal> bins) { binsProp = bins; }
    QList<qreal> bins() const { return binsProp; }
    QBindable<QList<qreal>> bindableBins() { return &binsProp; }

    void setDataTransform(QMatrix4x4 dataTransform) { dataTransformProp = dataTransform; }
    QMatrix4x4 dataTransform() const { return dataTransformProp; }
    QBindable<QMatrix4x4> bindableDataTransform() { return &dataTransformProp; }

    void setVertical(bool vertical) { verticalProp = vertical; }
    bool vertical() const { return verticalProp; }
    QBindable<bool> bindableVertical() { return &verticalProp; }

    QPolygonF path() const { return pathProp; }
    QBindable<QPolygonF> bindablePath() { return &pathProp; }

signals:
    void heightsChanged();
    void binsChanged();
    void dataTransformChanged();
    void verticalChanged();
    void pathChanged();

private:
    Q_OBJECT_BINDABLE_PROPERTY(HistogramHelper, QList<qreal>, heightsProp, &HistogramHelper::heightsChanged)
    Q_OBJECT_BINDABLE_PROPERTY(HistogramHelper, QList<qreal>, binsProp, &HistogramHelper::binsChanged)
    Q_OBJECT_BINDABLE_PROPERTY(HistogramHelper, QMatrix4x4, dataTransformProp, &HistogramHelper::dataTransformChanged)
    Q_OBJECT_BINDABLE_PROPERTY(HistogramHelper, bool, verticalProp, &HistogramHelper::verticalChanged)
    Q_OBJECT_BINDABLE_PROPERTY(HistogramHelper, QPolygonF, pathProp, &HistogramHelper::pathChanged)
};
