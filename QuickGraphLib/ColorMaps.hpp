// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QColor>
#include <QQmlEngine>

class ColorMaps : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

   public:
    enum ColorMapName { Grayscale, Magma, Inferno, Plasma, Viridis, Cividis, Twilight, TwilightShifted, Turbo };
    Q_ENUM(ColorMapName);

    Q_INVOKABLE QList<QColor> colors(ColorMapName colorMapName) const;
    Q_INVOKABLE QString colorMapName(ColorMapName colorMapName) const;
};

QList<QRgb> colors(ColorMaps::ColorMapName colorMapName);
