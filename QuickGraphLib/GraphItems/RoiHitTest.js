.pragma library

// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// SPDX-License-Identifier: MIT

function clamp(value, minValue, maxValue) {
    return Math.max(minValue, Math.min(maxValue, value));
}

function distanceToSegment(point, segmentStart, segmentEnd) {
    const segmentX = segmentEnd.x - segmentStart.x;
    const segmentY = segmentEnd.y - segmentStart.y;
    const lengthSquared = segmentX * segmentX + segmentY * segmentY;

    if (lengthSquared === 0) {
        const pointX = point.x - segmentStart.x;
        const pointY = point.y - segmentStart.y;
        return Math.sqrt(pointX * pointX + pointY * pointY);
    }

    const t = clamp(((point.x - segmentStart.x) * segmentX + (point.y - segmentStart.y) * segmentY) / lengthSquared, 0, 1);
    const closestX = segmentStart.x + t * segmentX;
    const closestY = segmentStart.y + t * segmentY;
    const dx = point.x - closestX;
    const dy = point.y - closestY;
    return Math.sqrt(dx * dx + dy * dy);
}

function isNearSegment(point, segmentStart, segmentEnd, hitWidth) {
    return distanceToSegment(point, segmentStart, segmentEnd) <= hitWidth / 2;
}

function isNearPolyline(point, points, hitWidth, closed) {
    if (points.length < 2) return false;

    for (let index = 0; index < points.length - 1; index++) {
        if (isNearSegment(point, points[index], points[index + 1], hitWidth)) return true;
    }

    return closed && isNearSegment(point, points[points.length - 1], points[0], hitWidth);
}

function isInsidePolygon(point, points) {
    if (points.length < 3) return false;

    let inside = false;
    for (let index = 0, previousIndex = points.length - 1; index < points.length; previousIndex = index++) {
        const current = points[index];
        const previous = points[previousIndex];
        const crossesY = current.y > point.y !== previous.y > point.y;
        if (!crossesY) continue;

        const intersectionX = (previous.x - current.x) * (point.y - current.y) / (previous.y - current.y) + current.x;
        if (point.x < intersectionX) inside = !inside;
    }
    return inside;
}

function isInsideEllipse(point, center, radiusX, radiusY) {
    if (radiusX <= 0 || radiusY <= 0) return false;

    const normalizedX = (point.x - center.x) / radiusX;
    const normalizedY = (point.y - center.y) / radiusY;
    return normalizedX * normalizedX + normalizedY * normalizedY <= 1;
}
