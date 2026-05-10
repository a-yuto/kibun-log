#if DEBUG
import Foundation
import SwiftData

/// 履歴グラフの見えを確認するためのダミーデータ生成器。Debug ビルドのみ。
/// 平日は気分やや低め・睡眠短め、週末は気分やや高め・睡眠長めの傾向を入れて、
/// 移動平均と曜日別サマリーが意味のある形で表示されるように設計。
@MainActor
struct DummyDataSeeder {

    /// 直近 `days` 日分のダミー記録を投入する。既存データは消す。
    @discardableResult
    func seed(context: ModelContext, days: Int = 60) throws -> Int {
        try clear(context: context)

        let calendar = Calendar.current
        let today = Date.now

        var generator = SystemRandomNumberGenerator()

        for offset in (0..<days).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { continue }
            let weekday = calendar.component(.weekday, from: date)
            let isWeekend = (weekday == 1 || weekday == 7)
            let isMonday = (weekday == 2)

            // 気分: 月曜やや低め、週末やや高め、それ以外は中庸
            let moodBase: Double = isMonday ? 4.0 : (isWeekend ? 7.5 : 6.0)
            let moodNoise = Double.random(in: -1.5...1.5, using: &generator)
            let mood = max(0, min(10, moodBase + moodNoise))

            // 睡眠: 平日 6.5h、週末 8.0h を中心に揺らす
            let sleepBase: Double = isWeekend ? 8.0 : 6.5
            let sleepNoise = Double.random(in: -1.0...1.0, using: &generator)
            let rawSleep = max(3.0, min(10.0, sleepBase + sleepNoise))
            let sleepHours = (rawSleep * 2).rounded() / 2  // 0.5 時間刻み

            // 半分くらいは HealthKit 由来のソースに見せる
            let source: SleepSource = Bool.random(using: &generator) ? .healthKit : .manual

            let entry = MoodEntry(
                date: noon(of: date, calendar: calendar),
                mood: mood,
                sleepHours: sleepHours,
                sleepSource: source
            )
            context.insert(entry)
        }
        try context.save()
        return days
    }

    /// 既存の `MoodEntry` を全削除する。
    func clear(context: ModelContext) throws {
        try context.delete(model: MoodEntry.self)
        try context.save()
    }

    private func noon(of date: Date, calendar: Calendar) -> Date {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        var noon = DateComponents()
        noon.year = components.year
        noon.month = components.month
        noon.day = components.day
        noon.hour = 12
        return calendar.date(from: noon) ?? date
    }
}
#endif
