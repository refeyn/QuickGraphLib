import QtQuick

/*!
    \qmltype AntialiasingContainer
    \inqmlmodule QuickGraphLib
    \inherits QtQuick::Item
    \brief Enables antialiasing for it's contents.
*/

Item {
    implicitHeight: 100
    implicitWidth: 100
    layer.enabled: true // Improves rendering of fractional DPIs
    layer.samples: 2
}
