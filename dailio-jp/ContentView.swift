import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            EntryView()
                .tabItem {
                    Label("記録", systemImage: "square.and.pencil")
                }

            HistoryView()
                .tabItem {
                    Label("履歴", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: MoodEntry.self, inMemory: true)
}
