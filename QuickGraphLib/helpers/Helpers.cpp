#include "Helpers.hpp"

const std::vector<qreal> STEPS = {0.2, 0.25, 0.5, 1};

QList<qreal> Helpers::linspace(qreal min, qreal max, int num) const {
    /*!
        \qmlmethod list<double> Helpers::linspace(double min, double max, int num)

        Returns a list of \a num values equally spaced from \a min and \a max (inclusive).
    */
    auto result = QList<qreal>();
    result.reserve(num);
    for (auto i = 0; i < num; ++i) {
        result.append(static_cast<qreal>(i) / (num - 1) * (max - min) + min);
    }
    return result;
}

QList<int> Helpers::range(int min, int max, int step /* = 1 */) const {
    /*!
        \qmlmethod list<int> Helpers::range(int min, int max, int step = 1)

        Returns a list of values from \a min to \a max (exclusive) with a gap of \a step between each one.
    */
    auto result = QList<int>();
    result.reserve((max - min) / step);
    for (auto i = min; i < max; i += step) {
        result.append(i);
    }
    return result;
}

QList<qreal> Helpers::tickLocator(qreal min, qreal max, int maxNum) const {
    /*!
        \qmlmethod list<double> Helpers::tickLocator(double min, double max, int maxNum)

        Returns a list of at most \a maxNum nice tick locations values equally spaced between \a min and \a max.
    */
    if (min == max || !std::isfinite(min) || !std::isfinite(max) || maxNum == 0) {
        return {};
    }
    if (max < min) {
        std::swap(min, max);
    }
    auto approxTickSpacing = (max - min) / (maxNum - 1);
    auto magnitude = std::ceil(std::log10(approxTickSpacing));
    auto normedTickSpacing = approxTickSpacing / std::pow(10, magnitude);
    auto tickSpacing = *std::find_if(STEPS.begin(), STEPS.end(), [normedTickSpacing](auto x){return x >= normedTickSpacing;}) * std::pow(10, magnitude);
    auto lower = std::ceil(min / tickSpacing - 1e-4) * tickSpacing;
    auto upper = std::floor(max / tickSpacing + 1e-4) * tickSpacing;
    auto numTicks = std::round((upper - lower) / tickSpacing + 1);
    Q_ASSERT_X(numTicks <= maxNum, "tickLocator", "Calculated too many ticks");
    return linspace(lower, upper, numTicks);
}
