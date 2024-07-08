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
    Q_PROPERTY(QSize source1DSize READ source1DSize WRITE setSource1DSize NOTIFY source1DSizeChanged BINDABLE
                   bindableSource1DSize)
    Q_PROPERTY(QVariant colormap READ colormap WRITE setColormap NOTIFY colormapChanged BINDABLE bindableColormap)
    Q_PROPERTY(qreal min READ min WRITE setMin NOTIFY minChanged BINDABLE bindableMin)
    Q_PROPERTY(qreal max READ max WRITE setMax NOTIFY maxChanged BINDABLE bindableMax)
    Q_PROPERTY(QSize sourceSize READ sourceSize NOTIFY sourceSizeChanged BINDABLE bindableSourceSize)
    Q_PROPERTY(QRectF paintedRect READ paintedRect NOTIFY paintedRectChanged BINDABLE bindablePaintedRect)

    QPropertyNotifier _mirrorHorizontallyNotifier, _mirrorVerticallyNotifier, _transposeNotifier, _sourceNotifier,
        _source1DSizeNotifier, _colormapNotifier, _minNotifier, _maxNotifier, _paintedRectNotifier;
    bool _textureDirty = false;
    QImage _coloredImage;

    void _calcColoredImage();

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

    void setSource1DSize(QSize source1DSize) { source1DSizeProp = source1DSize; }
    QSize source1DSize() const { return source1DSizeProp; }
    QBindable<QSize> bindableSource1DSize() { return &source1DSizeProp; }

    void setColormap(QVariant colormap) { colormapProp = colormap; }
    QVariant colormap() const { return colormapProp; }
    QBindable<QVariant> bindableColormap() { return &colormapProp; }

    void setMin(qreal min) { minProp = min; }
    qreal min() const { return minProp; }
    QBindable<qreal> bindableMin() { return &minProp; }

    void setMax(qreal max) { maxProp = max; }
    qreal max() const { return maxProp; }
    QBindable<qreal> bindableMax() { return &maxProp; }

    QSize sourceSize() const { return sourceSizeProp; }
    QBindable<QSize> bindableSourceSize() { return &sourceSizeProp; }

    QRectF paintedRect() const { return paintedRectProp; }
    QBindable<QRectF> bindablePaintedRect() { return &paintedRectProp; }

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
    void source1DSizeChanged();
    void colormapChanged();
    void minChanged();
    void maxChanged();
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
    Q_OBJECT_BINDABLE_PROPERTY(ImageView, QSize, source1DSizeProp, &ImageView::source1DSizeChanged)
    Q_OBJECT_BINDABLE_PROPERTY(ImageView, QVariant, colormapProp, &ImageView::colormapChanged)
    Q_OBJECT_BINDABLE_PROPERTY(ImageView, qreal, minProp, &ImageView::minChanged)
    Q_OBJECT_BINDABLE_PROPERTY_WITH_ARGS(ImageView, qreal, maxProp, 1.0, &ImageView::maxChanged)
    Q_OBJECT_BINDABLE_PROPERTY(ImageView, QSize, sourceSizeProp, &ImageView::sourceSizeChanged)
    Q_OBJECT_BINDABLE_PROPERTY(ImageView, QRectF, paintedRectProp, &ImageView::paintedRectChanged)
};
