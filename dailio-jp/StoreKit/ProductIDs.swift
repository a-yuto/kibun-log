import Foundation

/// StoreKit 2 のプロダクト識別子。App Store Connect / Configuration.storekit と一致させる。
enum ProductIDs {
    static let monthly = "niki.dailio-jp.pro.monthly"
    static let yearly = "niki.dailio-jp.pro.yearly"
    static let lifetime = "niki.dailio-jp.pro.lifetime"

    static let all: [String] = [monthly, yearly, lifetime]

    /// 表示順（月額 → 年額 → Lifetime）
    static let displayOrder: [String] = [monthly, yearly, lifetime]
}
