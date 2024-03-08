import QtQuick
import QtQuick.Shapes as QQS

/*!
    \qmltype Contours
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Draw a contour line or fill.
*/

QQS.ShapePath {
    id: root

    /*!
        TODO
    */
    required property matrix4x4 dataTransform
    /*!
        TODO
    */
    required property var paths

    capStyle: QQS.ShapePath.RoundCap
    fillColor: "transparent"
    joinStyle: QQS.ShapePath.RoundJoin

    PathMultiline {
        paths: root.paths.map(ps => ps.map(p => root.dataTransform.map(p)))
    }
}
