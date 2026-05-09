import SwiftUI
import SwiftData

@main
struct dailio_jpApp: App {
    @UIApplicationDelegateAdaptor(NotificationDelegate.self) private var notificationDelegate

    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            MoodEntry.self,
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    private let sleepProvider: any SleepProvider = HealthKitSleepProvider()
    @State private var entitlementStore = EntitlementStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.sleepProvider, sleepProvider)
                .environment(entitlementStore)
                .task {
                    await entitlementStore.refresh()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
