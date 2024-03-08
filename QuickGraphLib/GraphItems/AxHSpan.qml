import QtQuick

/*!
    \qmltype AxHSpan
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Rectangle
    \brief Displays a horizontal span.
*/

Rectangle {
    id: root

    /*! TODO */
    required property matrix4x4 dataTransform
    /*! TODO */
    required property double yMax
    /*! TODO */
    required property double yMin

    border.width: 0
    height: root.dataTransform.map(Qt.point(0, yMin)).y - root.dataTransform.map(Qt.point(0, yMax)).y
    width: parent.width + border.width * 4
    x: -border.width * 2
    y: root.dataTransform.map(Qt.point(0, yMax)).y
}
