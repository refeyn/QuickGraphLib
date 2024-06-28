// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QImage>
#include <QQuickItem>

class ColorMesh : public QQuickItem {
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
    Q_PROPERTY(QSize sourceSize READ sourceSize WRITE setSourceSize NOTIFY sourceSizeChanged BINDABLE bindableSourceSize
    )
    Q_PROPERTY(QVariant colormap READ colormap WRITE setColormap NOTIFY colormapChanged BINDABLE bindableColormap)
    Q_PROPERTY(qreal min READ min WRITE setMin NOTIFY minChanged BINDABLE bindableMin)
    Q_PROPERTY(qreal max READ max WRITE setMax NOTIFY maxChanged BINDABLE bindableMax)
    Q_PROPERTY(QRectF paintedRect READ paintedRect NOTIFY paintedRectChanged BINDABLE bindablePaintedRect)

    QPropertyNotifier _mirrorHorizontallyNotifier, _mirrorVerticallyNotifier, _transposeNotifier, _sourceNotifier,
        _sourceSizeNotifier, _colormapNotifier, _minNotifier, _maxNotifier, _paintedRectNotifier;
    bool _textureDirty = false;
    QImage _coloredImage;

    void _calcColoredImage();

   public:
    explicit ColorMesh(QQuickItem* parent = nullptr);

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

    void setSourceSize(QSize sourceSize) { sourceSizeProp = sourceSize; }
    QSize sourceSize() const { return sourceSizeProp; }
    QBindable<QSize> bindableSourceSize() { return &sourceSizeProp; }

    void setColormap(QVariant colormap) { colormapProp = colormap; }
    QVariant colormap() const { return colormapProp; }
    QBindable<QVariant> bindableColormap() { return &colormapProp; }

    void setMin(qreal min) { minProp = min; }
    qreal min() const { return minProp; }
    QBindable<qreal> bindableMin() { return &minProp; }

    void setMax(qreal max) { maxProp = max; }
    qreal max() const { return maxProp; }
    QBindable<qreal> bindableMax() { return &maxProp; }

    QRectF paintedRect() const { return paintedRectProp; }
    QBindable<QRectF> bindablePaintedRect() { return &paintedRectProp; }

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
    void sourceSizeChanged();
    void colormapChanged();
    void minChanged();
    void maxChanged();
    void paintedRectChanged();

   private:
    Q_OBJECT_BINDABLE_PROPERTY_WITH_ARGS(
        ColorMesh, int, fillModeProp, Qt::IgnoreAspectRatio, &ColorMesh::fillModeChanged
    )
    Q_OBJECT_BINDABLE_PROPERTY_WITH_ARGS(ColorMesh, int, alignmentProp, Qt::AlignCenter, &ColorMesh::alignmentChanged)
    Q_OBJECT_BINDABLE_PROPERTY(ColorMesh, bool, mirrorHorizontallyProp, &ColorMesh::mirrorHorizontallyChanged)
    Q_OBJECT_BINDABLE_PROPERTY(ColorMesh, bool, mirrorVerticallyProp, &ColorMesh::mirrorVerticallyChanged)
    Q_OBJECT_BINDABLE_PROPERTY(ColorMesh, bool, transposeProp, &ColorMesh::transposeChanged)
    Q_OBJECT_BINDABLE_PROPERTY(ColorMesh, QVariant, sourceProp, &ColorMesh::sourceChanged)
    Q_OBJECT_BINDABLE_PROPERTY(ColorMesh, QSize, sourceSizeProp, &ColorMesh::sourceSizeChanged)
    Q_OBJECT_BINDABLE_PROPERTY(ColorMesh, QVariant, colormapProp, &ColorMesh::colormapChanged)
    Q_OBJECT_BINDABLE_PROPERTY(ColorMesh, qreal, minProp, &ColorMesh::minChanged)
    Q_OBJECT_BINDABLE_PROPERTY_WITH_ARGS(ColorMesh, qreal, maxProp, 1.0, &ColorMesh::maxChanged)
    Q_OBJECT_BINDABLE_PROPERTY(ColorMesh, QRectF, paintedRectProp, &ColorMesh::paintedRectChanged)
};
