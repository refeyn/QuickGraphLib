// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <sbkpython.h>

#include "../DataTypes.hpp"

namespace ShibokenHelpers {
QGLDoubleList doubleListFromNDArray(PyObject *pyData);
QGLPolygonF polygonFFromNDArray(PyObject *pyData);
}  // namespace ShibokenHelpers
