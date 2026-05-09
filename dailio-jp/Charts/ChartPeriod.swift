import Foundation

/// 履歴グラフの表示期間。
enum ChartPeriod: String, CaseIterable, Identifiable, Sendable {
    case week
    case month
    case threeMonths
    case year

    var id: String { rawValue }

    /// 期間の日数。
    var dayCount: Int {
        switch self {
        case .week: 7
        case .month: 30
        case .threeMonths: 90
        case .year: 365
        }
    }

    /// セグメンテッドコントロール表示用ラベル。
    var label: LocalizedStringResource {
        switch self {
        case .week: "1週"
        case .month: "1ヶ月"
        case .threeMonths: "3ヶ月"
        case .year: "1年"
        }
    }
}
