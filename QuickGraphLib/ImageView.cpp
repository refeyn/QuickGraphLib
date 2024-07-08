// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// QuickGraphLib contributors SPDX-License-Identifier: MIT

#include "ImageView.hpp"

#include <QQuickWindow>
#include <QSGImageNode>

extern const std::map<QString, std::vector<QRgb>> DEFAULT_COLORMAPS;

/*!
    \qmltype ImageView
    \inqmlmodule QuickGraphLib
    \inherits QtQuick::Item
    \brief Display a colorized image from a 2D array.
*/

/*!
    \qmlproperty int ImageView::fillMode

        One of the following:

        \value Qt.IgnoreAspectRatio Stretch the image to fill
        \value Qt.KeepAspectRatio Preserve the aspect ratio
        \value Qt.KeepAspectRatioByExpanding Preserve the aspect ratio by cropping

        Defaults to \c Qt.IgnoreAspectRatio.

    \sa Qt::AspectRatioMode
*/

/*!
    \qmlproperty int ImageView::alignment

        A bitwise or of one horizontal and one vertical flag from the following:

        \value Qt.AlignLeft Left align
        \value Qt.AlignHCenter Center align (horizontally)
        \value Qt.AlignRight Right align
        \value Qt.AlignTop Top align
        \value Qt.AlignVCenter Center align (vertically)
        \value Qt.AlignBottom Bottom align

        Defaults to \c Qt.AlignCenter (which is \c {Qt.AlignHCenter | Qt.AlignVCenter}).

    \sa Qt::AlignmentFlag
*/

/*!
    \qmlproperty bool ImageView::mirrorHorizontally
    \qmlproperty bool ImageView::mirrorVertically

        Mirror the image horizontally and/or vertically.
*/

/*!
    \qmlproperty bool ImageView::transpose

        Transpose the image.
*/

/*!
    \qmlproperty var ImageView::source

        The data source for the displayed image. This can be a QImage, or a 1D/2D list of reals.

        If a list is provided, it will be converted to a color image using the \l colormap.
        A 1D list will be converted to a 2D list using \l sourceSize. The 2D data will be interpreted
        using "image" indexing (i.e. the first axis is Y and the second axis is X). If your data uses
        the opposite indexing scheme, use the \l transpose property to correct it.
*/

/*!
    \qmlproperty size ImageView::sourceSize

        The size \l source should be interpreted with. Only used when source is a 1D list.
*/

/*!
    \qmlproperty bool ImageView::smooth

        Sets whether the displayed image should be pixelated or smooth (linearly interpolated).
        Unlike other \l {Item}s, this property defaults to \c false.
*/

/*!
    \qmlproperty var ImageView::colormap

        The colormap to use when source is a list of values.
        This property can either take a \l Gradient, or a string name from the following options:

        \value "cividis" Monotonically increasing colormap (blue/brown/yellow)
        \value "grayscale" Monotonically increasing colormap (black/white)
        \value "inferno" Monotonically increasing colormap (black/red/yellow)
        \value "magma" Monotonically increasing colormap (blue/purple/red/yellow)
        \value "plasma" Monotonically increasing colormap (black/purple/red/yellow)
        \value "turbo" Multihue colormap (blue/green/yellow/red)
        \value "twilight" Cylical colormap (white/blue/black/red/white)
        \value "twilight_shifted" Cylical colormap (black/blue/white/red/black)
        \value "viridis" Monotonically increasing colormap (purple/green/yellow)

        More information about these colormaps can be found at in the
        \l {https://matplotlib.org/stable/users/explain/colors/colormaps.html} {matplotlib documentation}.

        The values of \l source are mapped to a color using \l min and \l max (i.e. if the value is
        less than or equal to min, it will be assigned the value at 0; if the value is greater than
        or equal to max, it will be assigned the value at 1).
        To invert a colormap, swap the values of \l min and \l max.

        The default colormap is grayscale.

        \note This property has no effect when \l source is a QImage.
*/

/*!
    \qmlproperty real ImageView::min

        The value which is mapped to 0 on the \l colormap.
*/

/*!
    \qmlproperty real ImageView::max

        The value which is mapped to 1 on the \l colormap.
*/

/*!
    \qmlproperty rect ImageView::paintedRect
    \readonly

        The rect that the image is painted in, in the ImageView's own coordinate space.
        If \l fillMode is \c Qt.IgnoreAspectRatio, this will equal \c {Qt.rect(0, 0, width, height)}.
*/

ImageView::ImageView(QQuickItem *parent) : QQuickItem{parent} {
    setFlags(QQuickItem::ItemHasContents);
    setSmooth(false);

    paintedRectProp.setBinding([this]() -> QRectF {
        auto itemRect = QRectF(0, 0, width(), height());
        auto rect = QRectF(
            itemRect.topLeft(),
            sourceSize().toSizeF().scaled(itemRect.size(), static_cast<Qt::AspectRatioMode>(fillMode()))
        );
        rect.moveCenter(itemRect.center());

        auto align = alignment();
        if (align & Qt::AlignLeft) {
            rect.moveLeft(0);
        }
        else if (align & Qt::AlignRight) {
            rect.moveRight(itemRect.width());
        }
        if (align & Qt::AlignTop) {
            rect.moveTop(0);
        }
        else if (align & Qt::AlignBottom) {
            rect.moveBottom(itemRect.height());
        }

        return rect;
    });

    // Must update paint node after these
    _mirrorHorizontallyNotifier = mirrorHorizontallyProp.addNotifier([this]() { update(); });
    _mirrorVerticallyNotifier = mirrorVerticallyProp.addNotifier([this]() { update(); });
    _paintedRectNotifier = paintedRectProp.addNotifier([this]() { update(); });

    // Must regenerate the texture after these
    _sourceNotifier = sourceProp.addNotifier([this]() { polish(); });
    _source1DSizeNotifier = source1DSizeProp.addNotifier([this]() { polish(); });
    _transposeNotifier = transposeProp.addNotifier([this]() { polish(); });
    _colormapNotifier = colormapProp.addNotifier([this]() { polish(); });
    _minNotifier = minProp.addNotifier([this]() { polish(); });
    _maxNotifier = maxProp.addNotifier([this]() { polish(); });
}

struct ColormapStop {
    qreal value;
    qreal diffFromPrev;
    QRgb color;
};

QRgb toColor(qreal value, const std::vector<ColormapStop> &colormap) {
    // Guaranteed to have at least one element in the colormap
    auto right = std::lower_bound(colormap.begin(), colormap.end(), value, [](const ColormapStop &stop, qreal value) {
        return stop.value < value;
    });
    if (right == colormap.begin()) {
        // Right at the start
        return right->color;
    }
    else if (right == colormap.end()) {
        // Beyond the end
        return colormap.back().color;
    }
    else if (right->value == value) {
        // Beyond the end
        return right->color;
    }
    else {
        auto left = right;
        --left;
        // Somewhere between left and right
        auto proportion = (value - left->value) / right->diffFromPrev;
        auto inverseProp = 1 - proportion;
        // Linear interpolation
        return qRgba(
            qRed(left->color) * inverseProp + qRed(right->color) * proportion,
            qGreen(left->color) * inverseProp + qGreen(right->color) * proportion,
            qBlue(left->color) * inverseProp + qBlue(right->color) * proportion,
            qAlpha(left->color) * inverseProp + qAlpha(right->color) * proportion
        );
    }
}

int indexForCoord(int x, int y, const QSize &size, bool transpose = false) {
    if (transpose) {
        return y + x * size.height();
    }
    else {
        return x + y * size.width();
    }
}

QImage convertToImageFrom1D(
    const QList<qreal> &converted, const QSize &size, const std::vector<ColormapStop> &colormap, bool transpose
) {
    if (size.width() * size.height() != converted.size()) {
        return {};
    }
    QImage image(size, QImage::Format_ARGB32_Premultiplied);
    QRgb *pixels = reinterpret_cast<QRgb *>(image.bits());
    for (auto x = 0; x < size.width(); ++x) {
        for (auto y = 0; y < size.height(); ++y) {
            pixels[indexForCoord(x, y, size, transpose)] = toColor(converted[indexForCoord(x, y, size)], colormap);
        }
    }

    return image;
}

QImage convertToImageFrom2D(
    const QList<QList<qreal>> &converted, const std::vector<ColormapStop> &colormap, bool transpose
) {
    QSize size(converted.isEmpty() ? 0 : converted[0].size(), converted.size());
    for (const auto &row : converted) {
        if (row.size() != size.width()) {
            return {};
        }
    }
    QImage image(size, QImage::Format_ARGB32_Premultiplied);
    QRgb *pixels = reinterpret_cast<QRgb *>(image.bits());
    for (auto y = 0; y < size.height(); ++y) {
        const auto &row = converted[y];
        for (auto x = 0; x < size.width(); ++x) {
            pixels[indexForCoord(x, y, size, transpose)] = toColor(row[x], colormap);
        }
    }
    return image;
}

QImage convertToImage(
    const QVariant &data, QSize suggestedSize, const std::vector<ColormapStop> &colormap, bool transpose
) {
    if (data.canConvert<QList<qreal>>()) {
        return convertToImageFrom1D(data.value<QList<qreal>>(), suggestedSize, colormap, transpose);
    }
    else if (data.canConvert<QList<QList<qreal>>>()) {
        return convertToImageFrom2D(data.value<QList<QList<qreal>>>(), colormap, transpose);
    }
    else if (data.canConvert<QVariantList>()) {
        auto halfWay = data.value<QVariantList>();
        if (halfWay.size() == 0) {
            return {};
        }
        if (halfWay[0].canConvert<qreal>()) {
            // 1D
            QList<qreal> converted;
            for (const auto &p : halfWay) {
                converted.append(p.toDouble());
            }
            return convertToImageFrom1D(converted, suggestedSize, colormap, transpose);
        }
        else {
            // 2D
            QList<QList<qreal>> converted;
            for (const auto &row : halfWay) {
                if (row.canConvert<QList<qreal>>()) {
                    converted.append(row.value<QList<qreal>>());
                }
                else if (row.canConvert<QVariantList>()) {
                    QList<qreal> rowConverted;
                    for (auto &item : row.value<QVariantList>()) {
                        rowConverted.append(item.toDouble());
                    }
                    converted.append(rowConverted);
                }
                else {
                    qWarning() << "convertToImage: Cannot interpret" << (row.typeName() ? row.typeName() : "null")
                               << "as an image row";
                    return {};
                }
            }
            return convertToImageFrom2D(converted, colormap, transpose);
        }
    }
    else {
        qWarning() << "convertToImage: Cannot interpret" << (data.typeName() ? data.typeName() : "null")
                   << "as an image";
        return {};
    }
}

void ImageView::updatePolish() {
    auto source = this->source();
    if (source.userType() == QMetaType::QImage) {
        _coloredImage = source.value<QImage>().convertToFormat(QImage::Format_ARGB32_Premultiplied);
        if (transpose()) {
            QImage transposedImage(_coloredImage.height(), _coloredImage.width(), QImage::Format_ARGB32_Premultiplied);
            const QRgb *pixels = reinterpret_cast<const QRgb *>(_coloredImage.constBits());
            QRgb *transposedPixels = reinterpret_cast<QRgb *>(transposedImage.bits());
            for (auto x = 0; x < _coloredImage.width(); ++x) {
                for (auto y = 0; y < _coloredImage.height(); ++y) {
                    transposedPixels[indexForCoord(x, y, _coloredImage.size(), true)] =
                        pixels[indexForCoord(x, y, _coloredImage.size())];
                }
            }
            _coloredImage = transposedImage;
        }
    }
    else {
        std::vector<ColormapStop> colormap;
        auto cmapVar = this->colormap();
        auto min = this->min();
        auto scale = this->max() - min;
        if (auto gradientObj = cmapVar.value<QObject *>()) {
            if (gradientObj && gradientObj->inherits("QQuickGradient")) {
                auto stops = QQmlListReference(gradientObj, "stops");
                for (auto stopsIndex = 0; stopsIndex < stops.size(); ++stopsIndex) {
                    auto stop = stops.at(stopsIndex);
                    auto value = min + stop->property("position").toDouble() * scale;
                    auto diff = colormap.size() == 0 ? 0 : value - colormap.back().value;
                    colormap.emplace_back(
                        ColormapStop{value, diff, qPremultiply(stop->property("color").value<QColor>().rgba())}
                    );
                }
                if (colormap.size() == 0) {
                    colormap.emplace_back(ColormapStop{min, 0, QColor(Qt::white).rgba()});
                }
            }
        }
        else if (cmapVar.canConvert<QString>()) {
            auto cmapName = cmapVar.toString();
            if (DEFAULT_COLORMAPS.count(cmapName)) {
                auto step = scale / DEFAULT_COLORMAPS.at(cmapName).size();
                auto pos = min;
                for (const auto &stop : DEFAULT_COLORMAPS.at(cmapName)) {
                    colormap.emplace_back(ColormapStop{pos, step, stop});
                    pos += step;
                }
            }
            else {
                colormap.emplace_back(ColormapStop{min, 0, QColor(Qt::white).rgba()});
            }
        }
        else {
            colormap.emplace_back(ColormapStop{min, 0, QColor(Qt::black).rgba()});
            colormap.emplace_back(ColormapStop{min + scale, scale, QColor(Qt::white).rgba()});
        }
        if (scale < 0) {
            std::reverse(colormap.begin(), colormap.end());
        }

        _coloredImage = convertToImage(source, source1DSize(), colormap, transpose());
    }

    setImplicitSize(_coloredImage.width(), _coloredImage.height());
    sourceSizeProp.setValue(_coloredImage.size());
    _textureDirty = true;
    update();
}

QSGNode *ImageView::updatePaintNode(QSGNode *node, UpdatePaintNodeData *) {
    Q_ASSERT(window() != nullptr);

    QSGImageNode *n = static_cast<QSGImageNode *>(node);
    if (!n) {
        n = window()->createImageNode();
        n->setOwnsTexture(true);
        _textureDirty = true;
    }
    if (_textureDirty) {
        n->setTexture(window()->createTextureFromImage(_coloredImage, QQuickWindow::TextureCanUseAtlas));
        _textureDirty = false;
    }
    n->setRect(paintedRect());
    QSGImageNode::TextureCoordinatesTransformMode mirrorFlags;
    if (mirrorHorizontally()) {
        mirrorFlags |= QSGImageNode::MirrorHorizontally;
    }
    if (mirrorVertically()) {
        mirrorFlags |= QSGImageNode::MirrorVertically;
    }
    n->setTextureCoordinatesTransform(mirrorFlags);
    n->setFiltering(smooth() ? QSGTexture::Linear : QSGTexture::Nearest);
    return n;
}

QImage ImageView::image() {
    ensurePolished();
    return _coloredImage;
}
