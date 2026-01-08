// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#include "Helpers.hpp"

#include <QFile>
#include <QMatrix4x4>
#include <QPainter>
#include <QPainterPath>
#include <QTextDocument>
#include <QtSvg/QSvgGenerator>

#include "ImageView.hpp"

/*!
    \qmltype Helpers
    \inqmlmodule QuickGraphLib
    \brief Helper functions for building graphs.
*/

/*!
    \class Helpers
    \inmodule QuickGraphLib
    \inheaderfile QuickGraphLib

    \brief Helper functions for building graphs.

    \sa QuickGraphLib::Helpers
*/

const std::vector<qreal> STEPS = {0.2, 0.25, 0.5, 1};

/*!
    \fn QList<qreal> Helpers::linspace(qreal min, qreal max, int num)

    Returns a list of \a num values equally spaced from \a min and \a max (inclusive).
*/
QList<qreal> Helpers::linspace(qreal min, qreal max, int num) {
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

/*!
    \fn QList<qreal> Helpers::logspace(qreal logmin, qreal logmax, int num, qreal base = 10)

    Returns a list of \a num values equally spaced from \a base to the power of \a logmin and \a base to the power
    of \a logmax (inclusive).
*/
QList<qreal> Helpers::logspace(qreal logmin, qreal logmax, int num, qreal base /*= 10*/) {
    /*!
        \qmlmethod list<real> Helpers::logspace(real logmin, real logmax, int num, real base = 10)

        Returns a list of \a num values equally spaced from \a base to the power of \a logmin and \a base to the power
        of \a logmax (inclusive).
    */
    auto result = QList<qreal>();
    for (auto power : Helpers::linspace(logmin, logmax, num)) {
        result.append(std::pow(base, power));
    }
    return result;
}

/*!
    \fn QList<int> Helpers::range(int min, int max, int step = 1)

    Returns a list of values from \a min to \a max (exclusive) with a gap of \a step between each one.
*/
QList<int> Helpers::range(int min, int max, int step /* = 1 */) {
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

/*!
    \fn QList<qreal> Helpers::tickLocator(qreal min, qreal max, int maxNum)

    Returns a list of at most \a maxNum nice tick locations values equally spaced between \a min and \a max.
*/
QList<qreal> Helpers::tickLocator(qreal min, qreal max, int maxNum) {
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

/*!
    \fn Helpers::mapPoints(QVariant points, QMatrix4x4 dataTransform)

    Maps each point in \a points though the transform defined by \a dataTransform.
*/
QPolygonF Helpers::mapPoints(QVariant points, QMatrix4x4 dataTransform) {
    /*!
        \qmlmethod QPolygonF Helpers::mapPoints(var points, matrix4x4 dataTransform)

        Maps each point in \a points though the transform defined by \a dataTransform.
        Essentially the same as \c{points.map(p => dataTransform.map(p))}, but more efficient.
    */
    if (points.canConvert<QPolygonF>()) {
        return mapPointsInner(points.value<QPolygonF>(), dataTransform);
    }
    else if (points.canConvert<QList<QPointF>>()) {
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
        qWarning() << "Helpers::mapPoints: Cannot interpret" << (points.typeName() ? points.typeName() : "null")
                   << "as a list of points";
        return {};
    }
}

void exportPathElementToPainterPath(QObject* element, QPainterPath& path) {
    if (element->inherits("QQuickPathPolyline")) {
        path.addPolygon(element->property("path").value<QList<QPointF>>());
    }
    else if (element->inherits("QQuickPathMultiline")) {
        auto paths = element->property("paths").value<QList<QList<QPointF>>>();

        for (auto& p : paths) {
            path.addPolygon(p);
        }
    }
    else if (element->inherits("QQuickPathLine")) {
        path.lineTo(element->property("x").toDouble(), element->property("y").toDouble());
    }
    else if (element->inherits("QQuickPathMove")) {
        path.moveTo(element->property("x").toDouble(), element->property("y").toDouble());
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
        else if (fillGradientObj->inherits("QQuickGradient") && simpleGradient.has_value()) {
            QRectF area;
            if (fillGradientObj->property("orientation").toInt() == Qt::Vertical) {
                area = {0, 0, 0, simpleGradient->height()};
            }
            else {
                area = {0, 0, simpleGradient->width(), 0};
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
    auto strokeStyle = static_cast<Qt::PenStyle>(shapePath->property("strokeStyle").toInt());
    pen.setStyle(strokeStyle);
    if (strokeStyle == Qt::PenStyle::DashLine) {
        pen.setDashOffset(shapePath->property("dashOffset").toDouble());
        pen.setDashPattern(shapePath->property("dashPattern").value<QList<qreal>>());
    }
    pen.setCapStyle(static_cast<Qt::PenCapStyle>(shapePath->property("capStyle").toInt()));
    pen.setJoinStyle(static_cast<Qt::PenJoinStyle>(shapePath->property("joinStyle").toInt()));
    pen.setMiterLimit(shapePath->property("miterLimit").toDouble());
    painter->setPen(pen);

    auto brush = brushFromColorAndGradient(shapePath->property("fillGradient"), shapePath->property("fillColor"), {});
    painter->setBrush(brush);

    QPainterPath path({shapePath->property("startX").toDouble(), shapePath->property("startY").toDouble()});
    path.setFillRule(static_cast<Qt::FillRule>(shapePath->property("fillRule").toInt()));

    auto elements = QQmlListReference(shapePath, "pathElements");
    for (auto elIndex = 0; elIndex < elements.count(); ++elIndex) {
        auto element = elements.at(elIndex);
        exportPathElementToPainterPath(element, path);
    }
    painter->drawPath(path);
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
        auto textFormat = static_cast<Qt::TextFormat>(item->property("textFormat").toInt());
        auto text = item->property("text").toString();
        auto alignment = static_cast<Qt::AlignmentFlag>(
            item->property("horizontalAlignment").toInt() | item->property("verticalAlignment").toInt()
        );
        if (textFormat == Qt::AutoText) {
            textFormat = Qt::mightBeRichText(text) ? Qt::RichText : Qt::PlainText;
        }
        if (textFormat == Qt::PlainText) {
            painter->drawText(rect, alignment, text);
        }
        else {
            QTextDocument doc;
            doc.setPageSize(QSizeF(item->width(), 0));
            doc.setDocumentMargin(0);
            doc.setTextWidth(item->width());
            if (textFormat == Qt::RichText) {
                doc.setHtml(text);
            }
            else {
                doc.setMarkdown(text);
            }
            QTextOption option;
            option.setAlignment(alignment);
            doc.setDefaultTextOption(option);
            doc.setDefaultFont(painter->font());
            doc.drawContents(painter, rect);
        }
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

    else if (item->inherits("ImageView")) {
        auto imageView = qobject_cast<ImageView*>(item);
        Q_ASSERT(imageView != nullptr);
        if (imageView->smooth()) {
            painter->setRenderHint(QPainter::RenderHint::SmoothPixmapTransform, true);
        }
        auto flippedFlags = Qt::Orientations();
        flippedFlags.setFlag(Qt::Horizontal, imageView->mirrorHorizontally());
        flippedFlags.setFlag(Qt::Vertical, imageView->mirrorVertically());
        painter->drawImage(imageView->paintedRect(), imageView->image().flipped(flippedFlags));
    }

    for (auto c : children) {
        if (c->z() >= 0) {
            exportItemToPainter(c, painter);
        }
    }
    painter->restore();
    if (item->clip() && painter->hasClipping()) {
        // Workaround for QTBUG-143246
        // If we have reverted to a previous clip, set it again to make sure it's applied
        painter->setClipRegion(painter->clipRegion());
    }
}

void exportToPainter(QQuickItem* item, QPainter* painter) {
    painter->setRenderHints(
        QPainter::RenderHint::Antialiasing | QPainter::RenderHint::TextAntialiasing |
            QPainter::RenderHint::LosslessImageRendering,
        true
    );

    // Cancel out translation done in exportItemToPainter
    painter->translate(-item->x(), -item->y());
    exportItemToPainter(item, painter);
}

void exportToPaintDevice(QQuickItem* item, QPaintDevice* device) {
    QPainter painter;
    painter.begin(device);
    exportToPainter(item, &painter);
    painter.end();
}

/*!
    \fn bool Helpers::exportToSvg(QQuickItem* item, QUrl path)

    Exports the graph in \a item to an SVG file at \a path. Returns a boolean indicating success.

    \note Only some QML elements are supported by this export method (e.g. \l {QtQuick::Rectangle} {Rectangle},
        PathPolyline). Other elements will be rendered incorrectly or not at all. See \l {QPainter-based export} for
        more information.

    \sa Helpers::exportToPng, Helpers::exportToPicture, {Exporting graphs}
*/
bool Helpers::exportToSvg(QQuickItem* item, QUrl path) {
    /*!
        \qmlmethod bool Helpers::exportToSvg(Item obj, url path)

        Exports the graph in \a obj to an SVG file at \a path. Returns a boolean indicating success.

        \note Only some QML elements are supported by this export method (e.g. \l {QtQuick::Rectangle} {Rectangle},
            PathPolyline). Other elements will be rendered incorrectly or not at all. See \l {QPainter-based export} for
            more information.

        \sa Helpers::exportToPng, Helpers::exportToPicture, {Exporting graphs}
    */

    if (!item) {
        return false;
    }

    {
        QSvgGenerator device{QSvgGenerator::SvgVersion::Svg11};
        device.setFileName(path.toLocalFile());
        device.setViewBox(QRectF(0, 0, item->width(), item->height()));
        device.setResolution(96);
        exportToPaintDevice(item, &device);
    }
    {
        QFile file(path.toLocalFile());
        if (!file.open(QIODevice::ReadWrite)) {
            return false;
        }
        QByteArray text = file.readAll();
        text.replace(QByteArray("image-rendering=\"optimizeSpeed\""), QByteArray("image-rendering=\"pixelated\""));
        file.seek(0);
        file.resize(text.length());
        file.write(text);
        file.close();
    }
    return true;
}

/*!
    \fn bool Helpers::exportToPng(QQuickItem* item, QUrl path, int dpi = 96 * 2)

    Exports the graph in \a item to an PNG file at \a path with the resolution \a dpi. Returns a boolean indicating
    success.

    \note Only some QML elements are supported by this export method (e.g. \l {QtQuick::Rectangle} {Rectangle},
        PathPolyline). Other elements will be rendered incorrectly or not at all. See \l {QPainter-based export} for
        more information.

    \sa Helpers::exportToSvg, Helpers::exportToPicture, {Exporting graphs}
*/
bool Helpers::exportToPng(QQuickItem* item, QUrl path, int dpi /* = 96 * 2 */) {
    /*!
        \qmlmethod bool Helpers::exportToPng(Item obj, url path, int dpi = 96 * 2)

        Exports the graph in \a obj to an PNG file at \a path with the resolution \a dpi. Returns a boolean indicating
        success.

        \note Only some QML elements are supported by this export method (e.g. \l {QtQuick::Rectangle} {Rectangle},
            PathPolyline). Other elements will be rendered incorrectly or not at all. See \l {QPainter-based export} for
            more information.

        \sa Helpers::exportToSvg, Helpers::exportToPicture, {Exporting graphs}
    */

    if (!item) {
        return false;
    }

    auto device = QPixmap(std::ceil(item->width() * dpi / 96), std::ceil(item->height() * dpi / 96));
    device.fill(Qt::GlobalColor::transparent);
    device.setDevicePixelRatio(dpi / 96);
    exportToPaintDevice(item, &device);
    return device.save(path.toLocalFile());
}

/*!
    \fn QPicture Helpers::exportToPicture(QQuickItem* item)

    Exports the graph in \a item to a QPicture.

    \note Only some QML elements are supported by this export method (e.g. \l {QtQuick::Rectangle} {Rectangle},
        PathPolyline). Other elements will be rendered incorrectly or not at all. See \l {QPainter-based export} for
        more information.

    \note Using this method, followed by saving to an image should give the same result as the other functions
        (ignoring some differences in the output that result in equivalent display). One exception is that exporting
        an ImageView as SVG will result in images rendering using the "optimiseSpeed" setting when they are not
        smooth. For reliable rendering across multiple programs, it is better to replace this with "pixelated". \l
        Helpers::exportToSvg does this correction automatically.

    \sa Helpers::exportToPng, Helpers::exportToSvg, {Exporting graphs}
*/
QPicture Helpers::exportToPicture(QQuickItem* item) {
    /*!
        \qmlmethod QPicture Helpers::exportToPicture(Item obj)

        Exports the graph in \a obj to a QPicture.

        \note Only some QML elements are supported by this export method (e.g. \l {QtQuick::Rectangle} {Rectangle},
            PathPolyline). Other elements will be rendered incorrectly or not at all. See \l {QPainter-based export} for
            more information.

        \note Using this method, followed by saving to an image should give the same result as the other functions
            (ignoring some differences in the output that result in equivalent display). One exception is that exporting
            an ImageView as SVG will result in images rendering using the "optimiseSpeed" setting when they are not
            smooth. For reliable rendering across multiple programs, it is better to replace this with "pixelated". \l
            Helpers::exportToSvg does this correction automatically.

        \sa Helpers::exportToPng, Helpers::exportToSvg, {Exporting graphs}
     */

    QPicture device;
    if (item) {
        exportToPaintDevice(item, &device);
    }
    return device;
}
