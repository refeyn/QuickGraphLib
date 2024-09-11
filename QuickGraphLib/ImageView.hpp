// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QImage>
#include <QQuickItem>

class ImageView : public QQuickItem {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int fillMode READ fillMode WRITE setFillMode NOTIFY fillModeChanged BINDABLE bindableFillMode)
    Q_PROPERTY(int alignment READ alignment WRITE setAlignment NOTIFY alignmentChanged BINDABLE bindableAlignment)
    Q_PROPERTY(bool mirrorHorizontally READ mirrorHorizontally WRITE setMirrorHorizontally NOTIFY
                   mirrorHorizontallyChanged BINDABLE bindableMirrorHorizontally)
    Q_PROPERTY(bool mirrorVertically READ mirrorVertically WRITE setMirrorVertically NOTIFY mirrorVerticallyChanged
                   BINDABLE bindableMirrorVertically)
    Q_PROPERTY(bool transpose READ transpose WRITE setTranspose NOTIFY transposeChanged BINDABLE bindableTranspose)
    Q_PROPERTY(QVariant source READ source WRITE setSource NOTIFY sourceChanged BINDABLE bindableSource)
    Q_PROPERTY(QVariant colormap READ colormap WRITE setColormap NOTIFY colormapChanged BINDABLE bindableColormap)
    Q_PROPERTY(qreal min READ min WRITE setMin NOTIFY minChanged)
    Q_PROPERTY(qreal max READ max WRITE setMax NOTIFY maxChanged)
    Q_PROPERTY(bool autoMin READ autoMin WRITE setAutoMin NOTIFY autoMinChanged BINDABLE bindableAutoMin)
    Q_PROPERTY(bool autoMax READ autoMax WRITE setAutoMax NOTIFY autoMaxChanged BINDABLE bindableAutoMax)
    Q_PROPERTY(QSize sourceSize READ sourceSize WRITE setSourceSize NOTIFY sourceSizeChanged)
    Q_PROPERTY(QRectF paintedRect READ paintedRect NOTIFY paintedRectChanged)

    QPropertyNotifier _mirrorHorizontallyNotifier, _mirrorVerticallyNotifier, _transposeNotifier, _sourceNotifier,
        _colormapNotifier, _autoMinNotifier, _autoMaxNotifier, _fillModeNotifier, _alignmentNotifier;
    bool _textureDirty = false;
    QImage _coloredImage;
    qreal _min = 0, _max = 1;
    QSize _sourceSize;
    QRectF _paintedRect;

    void _calcColoredImage();
    void _layout();

   public:
    explicit ImageView(QQuickItem* parent = nullptr);

    void setFillMode(int fillMode) { fillModeProp = fillMode; }
    int fillMode() const { return fillModeProp; }
    QBindable<int> bindableFillMode() { return &fillModeProp; }

    void setAlignment(int alignment) { alignmentProp = alignment; }
    int alignment() const { return alignmentProp; }
    QBindable<int> bindableAlignment() { return &alignmentProp; }

    void setMirrorHorizontally(bool mirrorHorizontally) { mirrorHorizontallyProp = mirrorHorizontally; }
    bool mirrorHorizontally() const { return mirrorHorizontallyProp; }
    QBindable<bool> bindableMirrorHorizontally() { return &mirrorHorizontallyProp; }

    void setMirrorVertically(bool mirrorVertically) { mirrorVerticallyProp = mirrorVertically; }
    bool mirrorVertically() const { return mirrorVerticallyProp; }
    QBindable<bool> bindableMirrorVertically() { return &mirrorVerticallyProp; }

    void setTranspose(bool transpose) { transposeProp = transpose; }
    bool transpose() const { return transposeProp; }
    QBindable<bool> bindableTranspose() { return &transposeProp; }

    void setSource(QVariant source) { sourceProp = source; }
    QVariant source() const { return sourceProp; }
    QBindable<QVariant> bindableSource() { return &sourceProp; }

    void setColormap(QVariant colormap) { colormapProp = colormap; }
    QVariant colormap() const { return colormapProp; }
    QBindable<QVariant> bindableColormap() { return &colormapProp; }

    void setMin(qreal min);
    qreal min() const { return _min; }

    void setMax(qreal max);
    qreal max() const { return _max; }

    void setAutoMin(bool autoMin) { autoMinProp = autoMin; }
    bool autoMin() const { return autoMinProp; }
    QBindable<bool> bindableAutoMin() { return &autoMinProp; }

    void setAutoMax(bool autoMax) { autoMaxProp = autoMax; }
    bool autoMax() const { return autoMaxProp; }
    QBindable<bool> bindableAutoMax() { return &autoMaxProp; }

    void setSourceSize(QSize sourceSize);
    QSize sourceSize() const { return _sourceSize; }

    QRectF paintedRect() const { return _paintedRect; }

    QImage image();

   protected:
    void updatePolish() override;
    QSGNode* updatePaintNode(QSGNode* node, UpdatePaintNodeData* data) override;

   signals:
    void fillModeChanged();
    void alignmentChanged();
    void mirrorHorizontallyChanged();
    void mirrorVerticallyChanged();
    void transposeChanged();
    void sourceChanged();
    void colormapChanged();
    void minChanged();
    void maxChanged();
    void autoMinChanged();
    void autoMaxChanged();
    void sourceSizeChanged();
    void paintedRectChanged();

   private:
    Q_OBJECT_BINDABLE_PROPERTY_WITH_ARGS(
        ImageView, int, fillModeProp, Qt::IgnoreAspectRatio, &ImageView::fillModeChanged
    )
    Q_OBJECT_BINDABLE_PROPERTY_WITH_ARGS(ImageView, int, alignmentProp, Qt::AlignCenter, &ImageView::alignmentChanged)
    Q_OBJECT_BINDABLE_PROPERTY(ImageView, bool, mirrorHorizontallyProp, &ImageView::mirrorHorizontallyChanged)
    Q_OBJECT_BINDABLE_PROPERTY(ImageView, bool, mirrorVerticallyProp, &ImageView::mirrorVerticallyChanged)
    Q_OBJECT_BINDABLE_PROPERTY(ImageView, bool, transposeProp, &ImageView::transposeChanged)
    Q_OBJECT_BINDABLE_PROPERTY(ImageView, QVariant, sourceProp, &ImageView::sourceChanged)
    Q_OBJECT_BINDABLE_PROPERTY(ImageView, QVariant, colormapProp, &ImageView::colormapChanged)
    Q_OBJECT_BINDABLE_PROPERTY_WITH_ARGS(ImageView, bool, autoMinProp, true, &ImageView::autoMinChanged)
    Q_OBJECT_BINDABLE_PROPERTY_WITH_ARGS(ImageView, bool, autoMaxProp, true, &ImageView::autoMaxChanged)
};
