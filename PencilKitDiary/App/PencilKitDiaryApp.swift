import SwiftUI
import SwiftData

/// アプリケーションのエントリポイント
@main
struct PencilKitDiaryApp: App {
    @State private var themeManager = ThemeManager()
    @State private var notificationManager = NotificationManager()
    @State private var weatherService = WeatherService()

    var body: some Scene {
        WindowGroup {
            ContentView(
                themeManager: themeManager,
                notificationManager: notificationManager,
                weatherService: weatherService
            )
            .tint(themeManager.theme.accentColorName.color)
        }
        .modelContainer(for: [
            DiaryEntry.self,
            Hashtag.self,
            Schedule.self,
            ReminderItem.self,
        ])
    }
}
