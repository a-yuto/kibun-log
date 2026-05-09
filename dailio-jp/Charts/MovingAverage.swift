import Foundation

/// 移動平均の純関数。Swift Charts に渡す前にデータを変換するためのもの。
struct MovingAverage: Sendable {

    /// `window` 日の移動平均を計算する。
    /// 始端では部分窓（要素 1 個から）の平均を返すので、グラフの線が冒頭から繋がる。
    /// 例: window = 7, values = [1,2,3,...] → 1 番目は 1、2 番目は (1+2)/2、…、7 番目以降は 7 個の平均。
    func calculate(values: [Double], window: Int) -> [Double] {
        precondition(window > 0, "window must be positive")
        guard !values.isEmpty else { return [] }

        var result: [Double] = []
        result.reserveCapacity(values.count)
        for i in values.indices {
            let start = max(0, i - window + 1)
            let slice = values[start...i]
            let avg = slice.reduce(0, +) / Double(slice.count)
            result.append(avg)
        }
        return result
    }
}
