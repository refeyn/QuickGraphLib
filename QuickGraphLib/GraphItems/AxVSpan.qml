import QtQuick

/*!
    \qmltype AxVSpan
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Rectangle
    \brief Displays an vertical span.
*/

Rectangle {
    id: root

    /*! TODO */
    required property matrix4x4 dataTransform
    /*! TODO */
    required property double xMax
    /*! TODO */
    required property double xMin

    border.width: 0
    height: parent.height + border.width * 4
    width: root.dataTransform.map(Qt.point(xMax, 0)).x - root.dataTransform.map(Qt.point(xMin, 0)).x
    x: root.dataTransform.map(Qt.point(xMin, 0)).x
    y: -border.width * 2
}
