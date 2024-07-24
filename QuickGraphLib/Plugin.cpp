// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// QuickGraphLib contributors SPDX-License-Identifier: MIT

#include <QtQml/qqmlextensionplugin.h>

#include "DataTypes.hpp"

extern void qml_register_types_QuickGraphLib();
Q_GHS_KEEP_REFERENCE(qml_register_types_QuickGraphLib)

class QuickGraphLibPlugin : public QQmlEngineExtensionPlugin {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlEngineExtensionInterface_iid)

   public:
    QuickGraphLibPlugin(QObject *parent = nullptr) : QQmlEngineExtensionPlugin(parent) {
        volatile auto registration = &qml_register_types_QuickGraphLib;
        Q_UNUSED(registration)
        registerConvertions();
    }
};

#include "Plugin.moc"
