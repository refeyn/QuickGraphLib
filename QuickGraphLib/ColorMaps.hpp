// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QColor>
#include <QQmlEngine>

QList<QRgb> colors(int colorMapName);

class ColorMaps : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

   public:
    enum ColorMapName { Grayscale, Magma, Inferno, Plasma, Viridis, Cividis, Twilight, TwilightShifted, Turbo };
    Q_ENUM(ColorMapName);

    Q_INVOKABLE QList<QColor> colors(int colorMapName) const;
    Q_INVOKABLE QString colorMapName(int colorMapName) const;
};
