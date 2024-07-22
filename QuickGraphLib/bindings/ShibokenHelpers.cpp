// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

#include "ShibokenHelpers.hpp"

#include <sbknumpyview.h>

template <class T>
QGLDoubleList _doubleListFromNDArray(const T *data, qsizetype length) {
    return QGLDoubleList(data, &data[length]);
}

QGLDoubleList ShibokenHelpers::doubleListFromNDArray(PyObject *pyData) {
    auto view = Shiboken::Numpy::View::fromPyObject(pyData);
    if (!view) {
        PyErr_Format(PyExc_TypeError, "Invalid array passed to QGLDoubleList.fromNDArray");
        return {};
    }
    if (view.ndim != 1) {
        PyErr_Format(PyExc_TypeError, "QGLDoubleList.fromNDArray expects a 1D array (got %d dims)", view.ndim);
        return {};
    }

    const qsizetype length = view.dimensions[0];

    switch (view.type) {
        case Shiboken::Numpy::View::Int16:
            return _doubleListFromNDArray(reinterpret_cast<const int16_t *>(view.data), length);
        case Shiboken::Numpy::View::Unsigned16:
            return _doubleListFromNDArray(reinterpret_cast<const uint16_t *>(view.data), length);
        case Shiboken::Numpy::View::Int:
            return _doubleListFromNDArray(reinterpret_cast<const int *>(view.data), length);
        case Shiboken::Numpy::View::Unsigned:
            return _doubleListFromNDArray(reinterpret_cast<const unsigned *>(view.data), length);
        case Shiboken::Numpy::View::Int64:
            return _doubleListFromNDArray(reinterpret_cast<const int64_t *>(view.data), length);
        case Shiboken::Numpy::View::Unsigned64:
            return _doubleListFromNDArray(reinterpret_cast<const uint64_t *>(view.data), length);
        case Shiboken::Numpy::View::Float:
            return _doubleListFromNDArray(reinterpret_cast<const float *>(view.data), length);
        case Shiboken::Numpy::View::Double:
            return _doubleListFromNDArray(reinterpret_cast<const double *>(view.data), length);
    }
    return {};
}

template <class T>
QGLPolygonF _polygonFFromNDArray(const T *data, qsizetype length) {
    QGLPolygonF result;
    result.reserve(length);
    for (auto i = 0; i < length; ++i) {
        auto x = *data++, y = *data++;
        result.append(QPointF(x, y));
    }
    return result;
}

QGLPolygonF ShibokenHelpers::polygonFFromNDArray(PyObject *pyData) {
    auto view = Shiboken::Numpy::View::fromPyObject(pyData);
    if (!view) {
        PyErr_Format(PyExc_TypeError, "Invalid array passed to QGLPolygonF.fromNDArray");
        return {};
    }
    if (view.ndim != 2) {
        PyErr_Format(PyExc_TypeError, "QGLPolygonF.fromNDArray expects a 2D array (got %d dims)", view.ndim);
        return {};
    }
    if (view.dimensions[1] != 2) {
        PyErr_Format(
            PyExc_TypeError, "QGLPolygonF.fromNDArray expects a Nx2 array (got %dx%d)", view.dimensions[0],
            view.dimensions[1]
        );
        return {};
    }

    const qsizetype length = view.dimensions[0];

    switch (view.type) {
        case Shiboken::Numpy::View::Int16:
            return _polygonFFromNDArray(reinterpret_cast<const int16_t *>(view.data), length);
        case Shiboken::Numpy::View::Unsigned16:
            return _polygonFFromNDArray(reinterpret_cast<const uint16_t *>(view.data), length);
        case Shiboken::Numpy::View::Int:
            return _polygonFFromNDArray(reinterpret_cast<const int *>(view.data), length);
        case Shiboken::Numpy::View::Unsigned:
            return _polygonFFromNDArray(reinterpret_cast<const unsigned *>(view.data), length);
        case Shiboken::Numpy::View::Int64:
            return _polygonFFromNDArray(reinterpret_cast<const int64_t *>(view.data), length);
        case Shiboken::Numpy::View::Unsigned64:
            return _polygonFFromNDArray(reinterpret_cast<const uint64_t *>(view.data), length);
        case Shiboken::Numpy::View::Float:
            return _polygonFFromNDArray(reinterpret_cast<const float *>(view.data), length);
        case Shiboken::Numpy::View::Double:
            return _polygonFFromNDArray(reinterpret_cast<const double *>(view.data), length);
    }
    return {};
}
