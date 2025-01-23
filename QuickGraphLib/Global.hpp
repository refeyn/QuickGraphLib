// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QtGlobal>

#if defined(QGL_LIBRARY)
#define QGL_EXPORT Q_DECL_EXPORT
#else
#define QGL_EXPORT Q_DECL_IMPORT
#endif
