// SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

/*!
    \qmltype Helpers
    \inqmlmodule QuickGraphLib
    \brief Helper functions for building graphs.
*/

// Indentation due to VSCode's formatter...
.import QtQuick as QQ
    .import QtQuick.Shapes as QQS

function linspace(min, max, num) {
    /*!
        \qmlmethod list<double> Helpers::linspace(double min, double max, int num)

        Returns a list of \a num values equally spaced from \a min and \a max (inclusive).
    */
    return Array.from((new Array(num)).keys(), i => i / (num - 1) * (max - min) + min);
}


function range(min, max, step) {
    /*!
        \qmlmethod list<int> Helpers::range(int min, int max, int step = 1)

        Returns a list of values from \a min to \a max (exclusive) with a gap of \a step between each one.
    */
    step = step ?? 1;
    let num = Math.max(0, Math.floor((max - min) / step));
    return Array.from((new Array(num)).keys(), i => min + step * i);
}

function tickLocator(min, max, maxNum) {
    /*!
        \qmlmethod list<double> Helpers::tickLocator(double min, double max, int maxNum)

        Returns a list of at most \a maxNum nice tick locations values equally spaced between \a min and \a max.
    */
    if (min == max || !isFinite(min) || !isFinite(max) || maxNum == 0) {
        return [];
    }
    if (max < min) {
        let tmp = max;
        max = min;
        min = tmp;
    }
    let steps = [0.2, 0.25, 0.5, 1];
    let approxTickSpacing = (max - min) / (maxNum - 1);
    let magnitude = Math.ceil(Math.log10(approxTickSpacing));
    let normedTickSpacing = approxTickSpacing / Math.pow(10, magnitude);
    let tickSpacing = steps.find(x => x >= normedTickSpacing) * Math.pow(10, magnitude);
    let lower = Math.ceil(min / tickSpacing - 1e-4) * tickSpacing;
    let upper = Math.floor(max / tickSpacing + 1e-4) * tickSpacing;
    let numTicks = Math.round((upper - lower) / tickSpacing + 1);
    console.assert(numTicks <= maxNum, "Calculated too many ticks");
    return Array.from((new Array(numTicks)).keys(), i => lower + i * tickSpacing);
}

function _exportTransform(t) {
    if (t instanceof QQ.Translate) {
        return {
            "type": "translate",
            "x": t.x,
            "y": t.y
        }
    } else if (t instanceof QQ.Rotation) {
        return {
            "type": "rotation",
            "angle": t.angle,
            "origin": t.origin
        }
    } else if (t instanceof QQ.Scale) {
        return {
            "type": "scale",
            "xScale": t.xScale,
            "yScale": t.yScale,
            "origin": t.origin
        }
    } else if (t instanceof QQ.Matrix4x4) {
        return {
            "type": "matrix4x4",
            "matrix": t.matrix
        }
    }
}

function _exportGradient(g) {
    if (g === null) {
        return null
    } else if (g instanceof QQS.LinearGradient) {
        return {
            "type": "lineargradient",
            "x1": g.x1,
            "x2": g.x2,
            "y1": g.y1,
            "y2": g.y2,
            "stops": g.stops.map(s => ({
                color: s.color, position: s.position
            }))
        }
    }
}

function exportData(obj) {
    /*!
        \qmlmethod var Helpers::exportData(Item obj)

        Returns information on \a obj which will allow it to be rendered to SVG/PNG using the Python helpers.

        \note Only some QML elements are supported by this export method (e.g. \l {QtQuick::Rectangle} {Rectangle}, PathPolyline).
        Other elements will be rendered incorrectly or not at all. If an element is not rendered correctly,
        create a new issue and we'll see if it can be added.

        \sa ExportHelper::exportToSvg, ExportHelper::exportToPng
    */
    let data = { "type": null, "js": obj.toString() };
    if (obj instanceof QQ.Item) {
        data.x = obj.x;
        data.y = obj.y;
        data.z = obj.z;
        data.width = obj.width;
        data.height = obj.height;
        data.children = obj.data.map(exportData);
        data.clip = obj.clip;
        data.transform = obj.transform.map(_exportTransform);
        data.opacity = obj.opacity;
        data.visible = obj.visible;

        if (obj instanceof QQ.Text) {
            data.type = "text";
            data.text = obj.text;
            data.color = obj.color;
            data.fontFamily = obj.font.family;
            data.fontSize = obj.font.pixelSize;
            data.fontWeight = obj.font.weight;
        }
        else if (obj instanceof QQ.Rectangle) {
            data.type = "rectangle";
            data.border_color = obj.border.color;
            data.border_width = obj.border.width;
            data.color = obj.color;
            data.radius = obj.radius;
            data.gradient = _exportGradient(obj.gradient);
        }
    }
    else if (obj instanceof QQS.ShapePath) {
        data.type = "shape_path";
        data.elements = obj.pathElements.map(exportData);
        data.capStyle = obj.capStyle;
        data.dashOffset = obj.dashOffset;
        data.dashPattern = obj.dashPattern.map(x => x);
        data.fillColor = obj.fillColor;
        data.fillGradient = _exportGradient(obj.fillGradient);
        data.fillRule = obj.fillRule;
        data.joinStyle = obj.joinStyle;
        data.miterLimit = obj.miterLimit;
        data.strokeColor = obj.strokeColor;
        data.strokeStyle = obj.strokeStyle;
        data.strokeWidth = obj.strokeWidth;
    }
    else if (obj instanceof QQ.PathPolyline) {
        data.type = "polyline";
        data.path = obj.path;
    }
    else if (obj instanceof QQ.PathMultiline) {
        data.type = "multiline";
        data.paths = obj.paths;
    }
    return data;
}