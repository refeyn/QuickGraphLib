// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// QuickGraphLib contributors SPDX-License-Identifier: MIT

#include "AxisHelper.hpp"

enum Direction { Left, Right, Top, Bottom };

AxisHelper::AxisHelper(QObject *parent) : QObject{parent} {
    _tickModel = new AxisTickModel(this);
    connect(this, &AxisHelper::pathChanged, _tickModel, &AxisTickModel::_updateToNewTicks);

    pathProp.setBinding([&]() -> QPolygonF {
        auto direction = directionProp.value();
        auto width = widthProp.value();
        auto height = heightProp.value();
        auto ticks = ticksProp.value();
        auto dataTransform = dataTransformProp.value();
        auto tickLength = tickLengthProp.value();

        auto isVertical = direction == Top || direction == Bottom;
        auto longAxis = isVertical ? width : height;
        std::sort(ticks.begin(), ticks.end());

        // Calculate everything as if we were a bottom axis
        auto points = QList{QPointF{0, 0}};
        points.reserve(ticks.size() * 3 + 2);
        QList<int> tickPositions;
        tickPositions.reserve(ticks.size());
        for (auto tick : ticks) {
            auto t = isVertical ? dataTransform.map(QPointF{tick, 0}).x() : dataTransform.map(QPointF{0, tick}).y();
            if (t >= -0.5 && t <= longAxis + 0.5) {
                points.emplaceBack(t, 0);
                points.emplaceBack(t, tickLength);
                points.emplaceBack(t, 0);
                tickPositions.append(points.size() - 2);
            }
            else {
                tickPositions.append(-1);
            }
        }
        points.emplaceBack(longAxis, 0);

        // Transform into the correct positions
        switch (direction) {
            case Left: {
                for (auto &p : points) {
                    auto x = p.x();
                    p.setX(width - p.y());
                    p.setY(x);
                }
                break;
            }
            case Right: {
                for (auto &p : points) {
                    auto x = p.x();
                    p.setX(p.y());
                    p.setY(x);
                }
                break;
            }
            case Top: {
                for (auto &p : points) {
                    p.setY(height - p.y());
                }
                break;
            }
            case Bottom: {
                break;
            }
        }

        // Axis stroke width is 1px, so round positions to the nearest half pixel so that the line covers a single
        // pixel.
        for (auto &p : points) {
            p.setY(round(p.y() + 0.5) - 0.5);
            p.setX(round(p.x() + 0.5) - 0.5);
        }

        // Update tick items model
        QList<AxisTickModel::TickData> tickDatas;
        auto tickIndex = 0u;
        for (auto tickPointsIndex : tickPositions) {
            if (tickPointsIndex != -1) {
                tickDatas.emplaceBack(AxisTickModel::TickData{points[tickPointsIndex], ticks[tickIndex]});
            }
            ++tickIndex;
        }
        _tickModel->_setNewTicks(tickDatas);

        return points;
    });
}

AxisTickModel::AxisTickModel(QObject *parent) : QAbstractListModel(parent) {}

int AxisTickModel::rowCount(const QModelIndex &parent) const { return parent.isValid() ? 0 : _ticks.size(); }

QVariant AxisTickModel::data(const QModelIndex &index, int role) const {
    if (!checkIndex(index, CheckIndexOption::IndexIsValid | CheckIndexOption::ParentIsInvalid)) {
        return {};
    }

    switch (role) {
        case Qt::DisplayRole: {
            return QString::number(_ticks[index.row()].value);
        }
        case AxisTickModel::PositionRole: {
            return _ticks[index.row()].position;
        }
        case AxisTickModel::ValueRole: {
            return _ticks[index.row()].value;
        }
        default: {
            return {};
        }
    }
}

QHash<int, QByteArray> AxisTickModel::roleNames() const {
    return {
        {Qt::DisplayRole, "display"},
        {AxisTickModel::PositionRole, "position"},
        {AxisTickModel::ValueRole, "value"},
    };
}

void AxisTickModel::_setNewTicks(const QList<AxisTickModel::TickData> &ticks) { _newTicks = ticks; }

void AxisTickModel::_updateToNewTicks() {
    auto oldCount = _ticks.count();
    if (oldCount < _newTicks.count()) {
        beginInsertRows({}, oldCount, _newTicks.count() - 1);
    }
    else if (oldCount > _newTicks.count()) {
        beginRemoveRows({}, _newTicks.count(), oldCount - 1);
    }
    _ticks = _newTicks;
    if (oldCount < _newTicks.count()) {
        endInsertRows();
    }
    else if (oldCount > _newTicks.count()) {
        endRemoveRows();
    }
    if (_newTicks.count()) {
        emit dataChanged(index(0), index(_newTicks.count() - 1));
    }
}
