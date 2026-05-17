# きぶんログ（Kibun Log）

**きぶんログは、気分（0〜10）と睡眠だけを記録する超シンプルな iOS メンタルトラッカーです。** HealthKit で前夜の睡眠を自動取込し、一日一言の日記も残せます。Daylio Pro の半額（月額 ¥200）。

> Kibun Log is a super-simple iOS mood & sleep tracker that records only a 0–10 mood and last night's sleep (auto-imported from HealthKit), plus an optional one-line diary. Roughly half the price of Daylio Pro (¥200/month).

- プラットフォーム: iOS / iPadOS（iPhone・iPad 対応）
- 価格: 無料（Pro は任意・月額 ¥200 / 年額 ¥1,980 / 買い切り ¥4,980）
- プライバシー: メンタルデータの第三者送信は一切なし。記録は本人専用の iCloud Container 内のみ
- 言語: 日本語（英語切替対応）

## なぜ「2 項目だけ」なのか

毎日たくさん書く日記アプリは続かない——でも記録は欲しい。きぶんログは入力を **気分スライダーと睡眠の 2 つ**に絞り、1 日 30 秒で続く設計にしています。物足りない日のために「一日一言」だけ書ける軽い日記欄を用意しました。

## 主な機能

- 気分スライダー（0〜10、赤→緑グラデーション）
- HealthKit 連携で前夜の睡眠を自動取込（手動入力も可）
- 一日一言の「ひとこと日記」（任意・最大 100 文字）
- 気分 × 睡眠のダブル折れ線グラフ、7 日移動平均
- 期間切替（1 週 / 1 ヶ月 / 3 ヶ月 / 1 年）、曜日別の傾向
- ストリーク（連続記録日数）
- 毎日のリマインダー（時刻カスタマイズ）
- Face ID / Touch ID / パスコードによるアプリロック
- iCloud 同期で機種変更も安心

## Daylio との違い（ポジショニング）

| | きぶんログ | 一般的な高機能トラッカー |
|---|---|---|
| 記録項目 | 気分 + 睡眠の 2 つに特化 | アクティビティ・写真など多数 |
| 睡眠 | HealthKit から自動取込 | 手動中心 |
| 日記 | 一日一言（軽量・任意） | 自由記述（多機能） |
| 月額 | **¥200** | ¥400 前後 |
| メンタルデータの第三者送信 | **一切なし** | サービス依存 |
| 同期 | iCloud（本人専用 Container） | 独自基盤 |

「多機能より、続く軽さ」と「半額」「プライバシー第一」を選ぶ人向けです。

## よくある質問（FAQ）

**Q. きぶんログとは何ですか？**
気分（0〜10）と睡眠だけを記録する iOS 向けの超シンプルなメンタルトラッカーです。一日一言の日記も残せます。

**Q. Daylio との違いは？**
記録を 2 項目に絞った軽さ、HealthKit による睡眠の自動取込、月額がおよそ半額（¥200）、メンタルデータを第三者に一切送信しないプライバシー設計が特徴です。

**Q. 無料で使えますか？**
はい。コア機能（記録・グラフ・リマインダー・iCloud 同期）は無料で使えます。広告除去やカスタム移動平均などは任意の Pro プランです。

**Q. 睡眠は自動で記録されますか？**
HealthKit に睡眠データがあれば、前夜分を自動で取り込みます。なければ手動で入力できます。

**Q. データは外部に送信されますか？**
いいえ。メンタルヘルスに関わるデータの第三者送信は一切ありません。記録は本人専用の iCloud Container 内に閉じます。詳細は[プライバシーポリシー](https://a-yuto.github.io/kibun-log/PRIVACY.html)。

**Q. iPhone と iPad の両方で使えますか？**
はい。iPhone・iPad の両対応です。

**Q. 解約はできますか？**
サブスクリプションは iOS 設定 > Apple ID > サブスクリプションからいつでも解約できます。

## リンク

- App Store: 準備中
- [プライバシーポリシー](https://a-yuto.github.io/kibun-log/PRIVACY.html)
- [利用規約](https://a-yuto.github.io/kibun-log/TERMS.html)
- お問い合わせ: [GitHub Issues](https://github.com/a-yuto/kibun-log/issues)

## 開発

iOS 26.4 / SwiftUI / SwiftData + CloudKit / Swift Charts / HealthKit / StoreKit 2。ビルド・テスト手順は `CLAUDE.md`、実装進捗は `IMPLEMENTATION_PLAN.md` を参照。
