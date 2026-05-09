import Foundation

/// 曜日別気分の集計器。「最高気分の曜日 / 最低気分の曜日」サマリーに使う。
struct WeekdayMoodAggregator: Sendable {

    struct WeekdayAverage: Hashable, Sendable {
        /// `Calendar.component(.weekday, from:)` の値（日=1, 月=2, ..., 土=7）
        let weekday: Int
        let average: Double
        let sampleCount: Int
    }

    let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    /// 曜日ごとに気分を平均する（記録のない曜日は結果に含まれない）。
    func averagesByWeekday(entries: [MoodEntry]) -> [WeekdayAverage] {
        var bucket: [Int: (sum: Double, count: Int)] = [:]
        for entry in entries {
            let weekday = calendar.component(.weekday, from: entry.date)
            let current = bucket[weekday] ?? (0, 0)
            bucket[weekday] = (current.sum + entry.mood, current.count + 1)
        }
        return bucket
            .map { WeekdayAverage(weekday: $0.key, average: $0.value.sum / Double($0.value.count), sampleCount: $0.value.count) }
            .sorted { $0.weekday < $1.weekday }
    }

    /// 平均気分が最も高い曜日。
    func bestWeekday(entries: [MoodEntry]) -> WeekdayAverage? {
        averagesByWeekday(entries: entries).max(by: { $0.average < $1.average })
    }

    /// 平均気分が最も低い曜日。
    func worstWeekday(entries: [MoodEntry]) -> WeekdayAverage? {
        averagesByWeekday(entries: entries).min(by: { $0.average < $1.average })
    }
}

extension WeekdayMoodAggregator.WeekdayAverage {
    /// 「月曜日」「火曜日」… のローカライズされた曜日名。
    func localizedName(calendar: Calendar = .current) -> String {
        let symbols = calendar.standaloneWeekdaySymbols
        let index = weekday - 1
        guard symbols.indices.contains(index) else { return "" }
        return symbols[index]
    }
}
