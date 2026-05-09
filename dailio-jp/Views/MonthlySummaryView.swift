import SwiftUI

/// 期間内の月次サマリー: 最高気分の曜日 / 最低気分の曜日。
struct MonthlySummaryView: View {
    let entries: [MoodEntry]

    private let aggregator = WeekdayMoodAggregator()

    private var best: WeekdayMoodAggregator.WeekdayAverage? {
        aggregator.bestWeekday(entries: entries)
    }

    private var worst: WeekdayMoodAggregator.WeekdayAverage? {
        aggregator.worstWeekday(entries: entries)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("曜日別の傾向")
                .font(.headline)

            row(
                title: "最高気分の曜日",
                value: best,
                icon: "arrow.up.right.circle.fill",
                color: .green
            )

            Divider()

            row(
                title: "最低気分の曜日",
                value: worst,
                icon: "arrow.down.right.circle.fill",
                color: .red
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private func row(
        title: LocalizedStringResource,
        value: WeekdayMoodAggregator.WeekdayAverage?,
        icon: String,
        color: Color
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
            Text(title)
                .font(.subheadline)
            Spacer()
            if let value {
                Text("\(value.localizedName())・\(value.average, format: .number.precision(.fractionLength(1)))")
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.primary)
            } else {
                Text("—")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    MonthlySummaryView(entries: [])
        .padding()
}
