// SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
// QuickGraphLib contributors SPDX-License-Identifier: MIT

#include "AxisHelper.hpp"

enum Direction { Left, Right, Top, Bottom };

AxisHelper::AxisHelper(QObject *parent) : QObject{parent} {
    _tickModel = new AxisTickModel(this);

    pathProp.setBinding([&]() -> QPolygonF {
        auto direction = directionProp.value();
        auto width = widthProp.value();
        auto height = heightProp.value();
        auto ticks = ticksProp.value();
        auto dataTransform = dataTransformProp.value();
        auto tickLength = tickLengthProp.value();

        auto longAxis = direction == Top || direction == Bottom ? width : height;

        // Calculate everything as if we were a bottom axis
        auto points = QList{QPointF{0, 0}};
        points.reserve(ticks.size() * 3 + 2);
        QList<int> tickPositions;
        tickPositions.reserve(ticks.size());
        for (auto tick : ticks) {
            auto t = direction == Top || direction == Bottom ? dataTransform.map(QPointF{tick, 0}).x()
                                                             : dataTransform.map(QPointF{0, tick}).y();
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

        // Update tick items model
        QList<AxisTickModel::TickData> tickDatas;
        auto tickIndex = 0u;
        for (auto tickPointsIndex : tickPositions) {
            if (tickPointsIndex != -1) {
                tickDatas.emplaceBack(AxisTickModel::TickData{points[tickPointsIndex], ticks[tickIndex]});
            }
            ++tickIndex;
        }
        _tickModel->_setTicks(std::move(tickDatas));

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
        {Qt::DisplayRole, {"display"}},
        {AxisTickModel::PositionRole, {"position"}},
        {AxisTickModel::ValueRole, {"value"}}
    };
}

void AxisTickModel::_setTicks(QList<AxisTickModel::TickData> &&ticks) {
    beginResetModel();
    _ticks = std::move(ticks);
    endResetModel();
}
