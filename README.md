# QuickGraphLib

A scientific graphing library for [QtQuick](https://doc.qt.io/qt-6/qtquick-index.html) using Qt6.

Links:
 - [Online documentation](https://refeyn.github.io/QuickGraphLib)
 - [PyPI page](https://pypi.org/project/QuickGraphLib/)
 - [Pre-built artefacts](https://github.com/refeyn/QuickGraphLib/releases/latest)

Key advantages:

 - Written in C++ and QML (with some optional Python helpers), so it can be used in both C++ and Python projects
 - QtQuick's hardware-based rendering makes this library render very fast
 - Support for line graphs, histograms, contour plots and more
 - Interactivity supported natively though declarative bindings and QtQuick
 - Support for PNG and SVG export

## Examples

The example gallery can be run using (provided the Python environment has [PySide6](https://pypi.org/project/PySide6/) and [contourpy](https://pypi.org/project/contourpy/) installed):

```bash
python examples/gallery.py
```

<p align="center"><img src="https://github.com/user-attachments/assets/19fa3b50-9a86-458d-b7c2-7a6fc95f0b6c" width="80%"></p>

## Qt version compatibility

This version of QuickGraphLib is compatible with Qt and PySide6 6.10.0. If you use this module from C++, then Qt's ABI stability guarantees means the compiled binaries will work for any Qt version >= 6.10 and < 7.0. If you use this module from Python, there are some additional features that rely on the PySide6 library version. Therefore the PySide6 version must be 6.10.0 exactly. Other 6.10 versions of PySide6 may work, but there are no guarantees.

## Python version compatibility

QuickGraphLib is compatible with the same Python versions and glibc versions that PySide6 is. For PySide6 6.10, the minimum Python version is 3.9.
