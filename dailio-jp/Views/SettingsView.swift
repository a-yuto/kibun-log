import SwiftUI
import UserNotifications

/// 設定画面: リマインダー時刻 / ON-OFF / 通知許可。
struct SettingsView: View {
    @AppStorage(ReminderSettingsKey.isEnabled)
    private var isReminderEnabled: Bool = ReminderSettingsDefaults.isEnabled

    @AppStorage(ReminderSettingsKey.hour)
    private var reminderHour: Int = ReminderSettingsDefaults.hour

    @AppStorage(ReminderSettingsKey.minute)
    private var reminderMinute: Int = ReminderSettingsDefaults.minute

    @State private var authorizationStatus: UNAuthorizationStatus = .notDetermined

    private let scheduler = NotificationScheduler()

    private var reminderTime: Binding<Date> {
        Binding(
            get: {
                Calendar.current.date(
                    bySettingHour: reminderHour,
                    minute: reminderMinute,
                    second: 0,
                    of: .now
                ) ?? .now
            },
            set: { newValue in
                let comp = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                reminderHour = comp.hour ?? ReminderSettingsDefaults.hour
                reminderMinute = comp.minute ?? ReminderSettingsDefaults.minute
            }
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("毎日のリマインダー", isOn: $isReminderEnabled)

                    if isReminderEnabled {
                        DatePicker(
                            "通知時刻",
                            selection: reminderTime,
                            displayedComponents: [.hourAndMinute]
                        )
                    }

                    if authorizationStatus == .denied {
                        Label("通知が iOS 設定でオフになっています", systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                            .font(.footnote)
                    } else if authorizationStatus == .notDetermined {
                        Button("通知を許可") {
                            Task { await requestAuthorization() }
                        }
                    }
                } header: {
                    Text("通知")
                } footer: {
                    Text("毎日の同じ時刻に記録を促す通知を送ります")
                }

                Section("このアプリについて") {
                    LabeledContent("バージョン", value: appVersion)
                }
            }
            .navigationTitle("設定")
            .task {
                await refreshAuthorization()
            }
            .onChange(of: isReminderEnabled) { _, _ in
                Task { await applyReminder() }
            }
            .onChange(of: reminderHour) { _, _ in
                Task { await applyReminder() }
            }
            .onChange(of: reminderMinute) { _, _ in
                Task { await applyReminder() }
            }
        }
    }

    // MARK: - Helpers

    private var appVersion: String {
        let dictionary = Bundle.main.infoDictionary ?? [:]
        let version = dictionary["CFBundleShortVersionString"] as? String ?? "—"
        let build = dictionary["CFBundleVersion"] as? String ?? "—"
        return "\(version) (\(build))"
    }

    private func refreshAuthorization() async {
        authorizationStatus = await scheduler.authorizationStatus()
    }

    private func requestAuthorization() async {
        do {
            _ = try await scheduler.requestAuthorization()
        } catch {
            // ユーザー操作中の取消などは握りつぶし
        }
        await refreshAuthorization()
        await applyReminder()
    }

    private func applyReminder() async {
        guard isReminderEnabled, authorizationStatus == .authorized else {
            scheduler.cancelDailyReminder()
            return
        }
        var components = DateComponents()
        components.hour = reminderHour
        components.minute = reminderMinute
        try? await scheduler.scheduleDailyReminder(at: components)
    }
}

#Preview {
    SettingsView()
}
