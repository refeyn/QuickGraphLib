// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#include "Helpers.hpp"

#include <QMatrix4x4>
#include <QPainter>
#include <QPainterPath>
#include <QtSvg/QSvgGenerator>

/*!
    \qmltype Helpers
    \inqmlmodule QuickGraphLib
    \brief Helper functions for building graphs.
*/

const std::vector<qreal> STEPS = {0.2, 0.25, 0.5, 1};

QList<qreal> Helpers::linspace(qreal min, qreal max, int num) const {
    /*!
        \qmlmethod list<real> Helpers::linspace(real min, real max, int num)

        Returns a list of \a num values equally spaced from \a min and \a max (inclusive).
    */
    auto result = QList<qreal>();
    if (num <= 0) {
        return result;
    }
    result.reserve(num);
    for (auto i = 0; i < num; ++i) {
        result.append(static_cast<qreal>(i) / (num - 1) * (max - min) + min);
    }
    return result;
}

QList<int> Helpers::range(int min, int max, int step /* = 1 */) const {
    /*!
        \qmlmethod list<int> Helpers::range(int min, int max, int step = 1)

        Returns a list of values from \a min to \a max (exclusive) with a gap of \a step between each one.
    */
    auto result = QList<int>();
    if (step == 0) {
        return result;
    }
    auto num = (max - min) / step;
    if (num <= 0) {
        return result;
    }
    result.reserve(num);
    for (auto i = min; i < max; i += step) {
        result.append(i);
    }
    return result;
}

QList<qreal> Helpers::tickLocator(qreal min, qreal max, int maxNum) const {
    /*!
        \qmlmethod list<real> Helpers::tickLocator(real min, real max, int maxNum)

        Returns a list of at most \a maxNum nice tick locations values equally spaced between \a min and \a max.
    */
    if (min == max || !std::isfinite(min) || !std::isfinite(max) || maxNum <= 0) {
        return {};
    }
    if (max < min) {
        std::swap(min, max);
    }
    auto approxTickSpacing = (max - min) / (maxNum - 1);
    auto magnitude = std::ceil(std::log10(approxTickSpacing));
    auto normedTickSpacing = approxTickSpacing / std::pow(10, magnitude);
    auto tickSpacing = *std::find_if(STEPS.begin(), STEPS.end(), [normedTickSpacing](auto x) {
        return x >= normedTickSpacing;
    }) * std::pow(10, magnitude);
    auto lower = std::ceil(min / tickSpacing - 1e-4) * tickSpacing;
    auto upper = std::floor(max / tickSpacing + 1e-4) * tickSpacing;
    auto numTicks = std::round((upper - lower) / tickSpacing + 1);
    Q_ASSERT_X(numTicks <= maxNum, "tickLocator", "Calculated too many ticks");
    return linspace(lower, upper, numTicks);
}

QPolygonF mapPointsInner(const QList<QPointF>& poly, QMatrix4x4 dataTranform) {
    QPolygonF newPoly;
    newPoly.reserve(poly.size());
    for (auto& point : poly) {
        newPoly.append(dataTranform.map(point));
    }
    return newPoly;
}

QPolygonF Helpers::mapPoints(QVariant points, QMatrix4x4 dataTransform) const {
    /*!
        \qmlmethod QPolygonF Helpers::mapPoints(var points, matrix4x4 dataTransform)

        Maps each point in \a points though the transform defined by \a dataTransform.
        Essentially the same as \c{points.map(p => dataTransform.map(p))}, but more efficient.
    */
    if (points.userType() == QMetaType::QPolygonF) {
        return mapPointsInner(points.value<QPolygonF>(), dataTransform);
    }
    else if (points.canConvert<QVector<QPointF>>()) {
        return mapPointsInner(points.value<QList<QPointF>>(), dataTransform);
    }
    else if (points.canConvert<QVariantList>()) {
        QList<QPointF> convertedPoints;
        for (const auto& p : points.value<QVariantList>()) {
            convertedPoints.append(p.toPointF());
        }
        return mapPointsInner(convertedPoints, dataTransform);
    }
    else {
        qWarning() << "Helpers::mapPoints: Cannot interpret" << points.userType() << "as a list of points";
        return {};
    }
}

void exportPathElementToPainter(QObject* element, QPainter* painter) {
    if (element->inherits("QQuickPathPolyline")) {
        auto brush = painter->brush();
        auto pen = painter->pen();
        auto path = element->property("path").value<QList<QPointF>>();
        painter->setPen(Qt::PenStyle::NoPen);
        painter->drawPolygon(path);
        painter->setPen(pen);
        painter->setBrush(Qt::BrushStyle::NoBrush);
        painter->drawPolyline(path);
        painter->setBrush(brush);
    }
    else if (element->inherits("QQuickPathMultiline")) {
        auto brush = painter->brush();
        auto pen = painter->pen();
        auto paths = element->property("paths").value<QList<QList<QPointF>>>();

        QPainterPath fill_path;
        for (auto& path : paths) {
            fill_path.addPolygon(QPolygonF(path));
            fill_path.closeSubpath();
        }

        painter->setPen(Qt::PenStyle::NoPen);
        painter->drawPath(fill_path);
        painter->setPen(pen);
        painter->setBrush(Qt::BrushStyle::NoBrush);
        for (auto& path : paths) {
            painter->drawPolyline(path);
        }
        painter->setBrush(brush);
    }
}

QBrush brushFromColorAndGradient(QVariant fillGradient, QVariant color, std::optional<QSizeF> simpleGradient) {
    if (fillGradient.canConvert<QJSValue>()) {
        fillGradient = fillGradient.value<QJSValue>().toVariant();
    }
    if (auto fillGradientObj = fillGradient.value<QObject*>()) {
        if (fillGradientObj->inherits("QQuickShapeLinearGradient")) {
            QRectF area{
                fillGradientObj->property("x1").toDouble(), fillGradientObj->property("y1").toDouble(),
                fillGradientObj->property("x2").toDouble(), fillGradientObj->property("y2").toDouble()
            };
            if (simpleGradient) {
                if (fillGradientObj->property("orientation").toInt() == Qt::Vertical) {
                    area = {0, 0, 0, simpleGradient->height()};
                }
                else {
                    area = {0, 0, simpleGradient->width(), 0};
                }
            }
            auto lingrad = QLinearGradient(area.topLeft(), area.bottomRight());
            auto stops = QQmlListReference(fillGradientObj, "stops");
            for (auto stopsIndex = 0; stopsIndex < stops.size(); ++stopsIndex) {
                auto stop = stops.at(stopsIndex);
                lingrad.setColorAt(stop->property("position").toDouble(), stop->property("color").value<QColor>());
            }
            return QBrush(lingrad);
        }
    }
    return QBrush(color.value<QColor>());
}

void exportShapePathToPainter(QObject* shapePath, QPainter* painter) {
    painter->save();
    auto pen = QPen(shapePath->property("strokeColor").value<QColor>());
    pen.setWidth(shapePath->property("strokeWidth").toDouble());
    painter->setPen(pen);
    auto brush = brushFromColorAndGradient(shapePath->property("fillGradient"), shapePath->property("fillColor"), {});
    painter->setBrush(brush);

    auto elements = QQmlListReference(shapePath, "pathElements");
    for (auto elIndex = 0; elIndex < elements.count(); ++elIndex) {
        auto element = elements.at(elIndex);
        exportPathElementToPainter(element, painter);
    }
    painter->restore();
}

void exportItemToPainter(QQuickItem* item, QPainter* painter) {
    if (!item->isVisible()) {
        return;
    }
    painter->save();
    painter->translate(item->x(), item->y());
    painter->setOpacity(item->opacity());
    auto rect = QRectF(0, 0, item->width(), item->height());
    if (item->clip()) {
        // Note: doesn't work for SVGs until 6.7
        painter->setClipRect(rect);
    }

    auto children = item->childItems();

    std::sort(children.begin(), children.end(), [](auto a, auto b) { return a->z() < b->z(); });

    auto transforms = QQmlListReference(item, "transform");
    for (auto trIndex = transforms.size() - 1; trIndex >= 0; --trIndex) {
        auto tr = transforms.at(trIndex);
        Q_ASSERT(tr != nullptr);
        if (tr->inherits("QQuickTranslate")) {
            painter->translate(tr->property("x").toDouble(), tr->property("y").toDouble());
        }
        else if (tr->inherits("QQuickRotation")) {
            auto origin = tr->property("origin").value<QVector3D>();
            painter->translate(origin.x(), origin.y());
            painter->rotate(tr->property("angle").toDouble());
            painter->translate(-origin.x(), -origin.y());
        }
        else if (tr->inherits("QQuickScale")) {
            auto origin = tr->property("origin").value<QVector3D>();
            painter->translate(origin.x(), origin.y());
            painter->scale(tr->property("xScale").toDouble(), tr->property("yScale").toDouble());
            painter->translate(-origin.x(), -origin.y());
        }
        else if (tr->inherits("QQuickMatrix4x4")) {
            painter->setTransform(tr->property("matrix").value<QMatrix4x4>().toTransform(), true);
        }
    }

    for (auto c : children) {
        if (c->z() < 0) {
            exportItemToPainter(c, painter);
        }
    }

    if (item->inherits("QQuickText")) {
        painter->save();
        painter->setFont(item->property("font").value<QFont>());
        painter->setPen(item->property("color").value<QColor>());
        painter->drawText(rect, item->property("text").toString());
        painter->restore();
    }

    else if (item->inherits("QQuickRectangle")) {
        auto borderProp = item->property("border").value<QObject*>();
        Q_ASSERT(borderProp != nullptr);
        painter->save();
        auto pen = QPen(Qt::PenStyle::NoPen);
        if (borderProp->property("width").toDouble() > 0) {
            pen = QPen(borderProp->property("color").value<QColor>());
            pen.setWidthF(borderProp->property("width").toDouble());
        }
        painter->setPen(pen);

        auto brush = brushFromColorAndGradient(item->property("gradient"), item->property("color"), {item->size()});
        painter->setBrush(brush);
        painter->drawRoundedRect(rect, item->property("radius").toDouble(), item->property("radius").toDouble());
        painter->restore();
    }

    else if (item->inherits("QQuickShape")) {
        auto datas = QQmlListReference(item, "data");
        for (auto dIndex = 0; dIndex < datas.size(); ++dIndex) {
            auto data = datas.at(dIndex);
            Q_ASSERT(data != nullptr);
            if (data->inherits("QQuickShapePath")) {
                exportShapePathToPainter(data, painter);
            }
        }
    }

    for (auto c : children) {
        if (c->z() >= 0) {
            exportItemToPainter(c, painter);
        }
    }
    painter->restore();
}

void exportToPainter(QQuickItem* item, QPainter* painter) {
    painter->setRenderHint(QPainter::RenderHint::Antialiasing, true);
    painter->setRenderHint(QPainter::RenderHint::TextAntialiasing, true);

    // Cancel out translation done in _export_child_to_painter
    painter->translate(-item->x(), -item->y());
    exportItemToPainter(item, painter);
}

void exportToPaintDevice(QQuickItem* item, QPaintDevice* device) {
    QPainter painter;
    painter.begin(device);
    exportToPainter(item, &painter);
    painter.end();
}

bool Helpers::exportToSvg(QQuickItem* item, QUrl path) const {
    /*!
        \qmlmethod bool Helpers::exportToSvg(Item obj, url path)

        Exports the graph in \a obj to an SVG file at \a path. Returns a boolean indicating success.

        \note Only some QML elements are supported by this export method (e.g. \l {QtQuick::Rectangle} {Rectangle},
            PathPolyline). Other elements will be rendered incorrectly or not at all. If an element is not rendered
            correctly, create a new issue and we'll see if it can be added.

        \sa Helpers::exportToPng, Helpers::exportToPicture
    */

    QSvgGenerator device;
    device.setFileName(path.toLocalFile());
    device.setViewBox(QRectF(0, 0, item->width(), item->height()));
    device.setResolution(96);
    exportToPaintDevice(item, &device);
    return true;  // TODO How do we detect IO errors?
}

bool Helpers::exportToPng(QQuickItem* item, QUrl path, int dpi /* = 96 * 2 */) const {
    /*!
        \qmlmethod void Helpers::exportToPng(Item obj, url path, int dpi = 96 * 2)

        Exports the graph in \a obj to an PNG file at \a path with the resolution \a dpi. Returns a boolean indicating
        success.

        \note Only some QML elements are supported by this export method (e.g. \l {QtQuick::Rectangle} {Rectangle},
            PathPolyline). Other elements will be rendered incorrectly or not at all. If an element is not rendered
            correctly, create a new issue and we'll see if it can be added.

        \sa Helpers::exportToSvg, Helpers::exportToPicture
    */

    auto device = QPixmap(std::ceil(item->width() * dpi / 96), std::ceil(item->height() * dpi / 96));
    device.fill(Qt::GlobalColor::transparent);
    device.setDevicePixelRatio(dpi / 96);
    exportToPaintDevice(item, &device);
    return device.save(path.toLocalFile());
}

QPicture Helpers::exportToPicture(QQuickItem* item) const {
    /*!
        \qmlmethod QPicture Helpers::exportToPicture(Item obj)

         Exports the graph in \a obj to a QPicture.

          \note Only some QML elements are supported by this export method (e.g. \l {QtQuick::Rectangle} {Rectangle},
              PathPolyline). Other elements will be rendered incorrectly or not at all. If an element is not rendered
              correctly, create a new issue and we'll see if it can be added.

         \sa Helpers::exportToPng, Helpers::exportToSvg
     */

    QPicture device;
    exportToPaintDevice(item, &device);
    return device;
}
