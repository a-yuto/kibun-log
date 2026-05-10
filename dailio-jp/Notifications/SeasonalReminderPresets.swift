import Foundation

/// 季節要素を盛り込んだリマインダー文言プリセット。
/// issue「日本市場向け差別化」: 春の不調 / 五月病 / 梅雨だるさ / 夏バテ / 冬季の不調 など。
struct SeasonalReminderPresets: Sendable {
    let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    /// 指定日付に応じたリマインダー本文。季節に該当しなければ通常文言。
    func body(for date: Date = .now) -> String {
        let month = calendar.component(.month, from: date)
        switch month {
        case 4:
            return String(localized: "春の不調が出やすい時期です。今日の気分を残しておきましょう")
        case 5:
            return String(localized: "五月病に注意。今日の気分を 1 タップで記録できます")
        case 6:
            return String(localized: "梅雨のだるさは記録すると客観視できます。30 秒どうぞ")
        case 7, 8:
            return String(localized: "夏バテで眠れていますか？気分と睡眠を残しておきましょう")
        case 9:
            return String(localized: "季節の変わり目こそ、自分の調子を観察するチャンスです")
        case 11, 12, 1:
            return String(localized: "日が短い時期は気分が落ちやすいもの。記録で傾向を掴みましょう")
        default:
            return String(localized: "気分と昨夜の睡眠を 30 秒で記録できます")
        }
    }

    /// 指定日付のリマインダータイトル。
    func title(for date: Date = .now) -> String {
        String(localized: "今日の気分を記録しましょう")
    }
}
