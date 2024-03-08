import QtQuick
import QtQuick.Shapes as QQS

/*!
    \qmltype Histogram
    \inqmlmodule QuickGraphLib.GraphItems
    \inherits QtQuick::Shapes::ShapePath
    \brief Displays a histogram.
*/

QQS.ShapePath {
    id: root

    /*! TODO */
    required property var bins
    /*! TODO */
    required property matrix4x4 dataTransform
    /*! TODO */
    required property var heights
    /*! TODO */
    property bool vertical: false

    function _calculatePoints(bins, heights) {
        if (bins.length != heights.length + 1) {
            print(bins.length, heights.length);
            return [];
        }
        let points = [Qt.point(bins[0], 0)];
        heights.forEach((h, i) => {
            points.push(Qt.point(bins[i], h));
            points.push(Qt.point(bins[i + 1], h));
        });
        points.push(Qt.point(bins[bins.length - 1], 0));
        if (root.vertical) {
            return points.map(p => Qt.point(p.y, p.x));
        } else {
            return points;
        }
    }

    capStyle: QQS.ShapePath.RoundCap
    joinStyle: QQS.ShapePath.RoundJoin

    PathPolyline {
        path: root._calculatePoints(root.bins, root.heights).map(p => root.dataTransform.map(p))
    }
}
