import SwiftUI
import SwiftData
import Charts

/// 気分・睡眠の履歴を Swift Charts で可視化する画面。
struct HistoryView: View {
    @Query(sort: \MoodEntry.date, order: .forward) private var allEntries: [MoodEntry]

    @State private var period: ChartPeriod = .month
    @State private var showMovingAverage: Bool = true

    private var filteredEntries: [MoodEntry] {
        let calendar = Calendar.current
        let cutoff = calendar.date(byAdding: .day, value: -period.dayCount, to: .now) ?? .now
        return allEntries.filter { $0.date >= cutoff }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Picker("期間", selection: $period) {
                        ForEach(ChartPeriod.allCases) { period in
                            Text(period.label).tag(period)
                        }
                    }
                    .pickerStyle(.segmented)

                    if filteredEntries.isEmpty {
                        emptyState
                    } else {
                        Toggle(isOn: $showMovingAverage) {
                            Text("7日移動平均")
                                .font(.subheadline)
                        }

                        moodChartSection
                        sleepChartSection
                        MonthlySummaryView(entries: filteredEntries)
                    }
                }
                .padding()
            }
            .navigationTitle("履歴")
        }
    }

    // MARK: - Sections

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("記録がまだありません")
                .font(.headline)
            Text("数日続けるとここにグラフが表示されます")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }

    private var moodChartSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("気分")
                .font(.headline)
            MoodChart(
                entries: filteredEntries,
                showMovingAverage: showMovingAverage
            )
            .frame(height: 200)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private var sleepChartSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("睡眠")
                .font(.headline)
            SleepChart(
                entries: filteredEntries,
                showMovingAverage: showMovingAverage
            )
            .frame(height: 200)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

// MARK: - Mood Chart

private struct MoodChart: View {
    let entries: [MoodEntry]
    let showMovingAverage: Bool

    private var movingAverage: [Double] {
        MovingAverage().calculate(values: entries.map(\.mood), window: 7)
    }

    var body: some View {
        Chart {
            ForEach(Array(entries.enumerated()), id: \.element.persistentModelID) { index, entry in
                LineMark(
                    x: .value("日付", entry.date),
                    y: .value("気分", entry.mood)
                )
                .foregroundStyle(by: .value("series", "raw"))
                .opacity(showMovingAverage ? 0.3 : 1.0)

                if showMovingAverage, movingAverage.indices.contains(index) {
                    LineMark(
                        x: .value("日付", entry.date),
                        y: .value("移動平均", movingAverage[index])
                    )
                    .foregroundStyle(by: .value("series", "movingAverage"))
                    .lineStyle(StrokeStyle(lineWidth: 2.5))
                }
            }
        }
        .chartYScale(domain: 0...10)
        .chartForegroundStyleScale([
            "raw": Color.accentColor,
            "movingAverage": Color.orange
        ])
        .chartLegend(.hidden)
    }
}

// MARK: - Sleep Chart

private struct SleepChart: View {
    let entries: [MoodEntry]
    let showMovingAverage: Bool

    private var entriesWithSleep: [MoodEntry] {
        entries.filter { $0.sleepHours != nil }
    }

    private var movingAverage: [Double] {
        let values = entriesWithSleep.compactMap(\.sleepHours)
        return MovingAverage().calculate(values: values, window: 7)
    }

    var body: some View {
        Chart {
            ForEach(Array(entriesWithSleep.enumerated()), id: \.element.persistentModelID) { index, entry in
                if let hours = entry.sleepHours {
                    LineMark(
                        x: .value("日付", entry.date),
                        y: .value("睡眠時間", hours)
                    )
                    .foregroundStyle(by: .value("series", "raw"))
                    .opacity(showMovingAverage ? 0.3 : 1.0)

                    if showMovingAverage, movingAverage.indices.contains(index) {
                        LineMark(
                            x: .value("日付", entry.date),
                            y: .value("移動平均", movingAverage[index])
                        )
                        .foregroundStyle(by: .value("series", "movingAverage"))
                        .lineStyle(StrokeStyle(lineWidth: 2.5))
                    }
                }
            }
        }
        .chartYScale(domain: 0...12)
        .chartForegroundStyleScale([
            "raw": Color.blue,
            "movingAverage": Color.orange
        ])
        .chartLegend(.hidden)
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: MoodEntry.self, inMemory: true)
}
