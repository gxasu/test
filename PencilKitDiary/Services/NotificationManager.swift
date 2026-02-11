import Foundation
import UserNotifications

/// 通知マネージャー — ふりかえり通知・リマインド通知の管理（UC 33-44）
@Observable
final class NotificationManager {
    var settings: NotificationSettings

    private let settingsKey = "notificationSettings"

    init() {
        if let data = UserDefaults.standard.data(forKey: settingsKey),
           let saved = try? JSONDecoder().decode(NotificationSettings.self, from: data) {
            self.settings = saved
        } else {
            self.settings = .default
        }
    }

    // MARK: - 権限リクエスト

    func requestAuthorization() async -> Bool {
        let center = UNUserNotificationCenter.current()
        return (try? await center.requestAuthorization(options: [.alert, .sound, .badge])) ?? false
    }

    // MARK: - 通知スケジュール

    /// すべての通知を再スケジュール
    func rescheduleAll() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        if settings.isAnniversaryEnabled {
            scheduleAnniversaryNotification()
        }
        if settings.isPeriodicReminderEnabled {
            schedulePeriodicReminder()
        }

        saveSettings()
    }

    /// ○年前の日記通知（UC 35）
    private func scheduleAnniversaryNotification() {
        let center = UNUserNotificationCenter.current()

        for year in settings.lookbackYears {
            let content = UNMutableNotificationContent()
            content.title = "ふりかえり"
            content.body = "\(year)年前の今日、どんな一日でしたか？"
            content.sound = .default

            var dateComponents = DateComponents()
            dateComponents.hour = settings.notificationHour
            dateComponents.minute = settings.notificationMinute

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "anniversary_\(year)",
                content: content,
                trigger: trigger
            )
            center.add(request)
        }
    }

    /// 定期リマインド通知（UC 38）
    private func schedulePeriodicReminder() {
        let center = UNUserNotificationCenter.current()

        for weekday in settings.periodicReminderWeekdays {
            let content = UNMutableNotificationContent()
            content.title = "日記を書きましょう"
            content.body = "今日の出来事を記録しませんか？"
            content.sound = .default

            var dateComponents = DateComponents()
            dateComponents.weekday = weekday
            dateComponents.hour = settings.notificationHour
            dateComponents.minute = settings.notificationMinute

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "periodic_\(weekday)",
                content: content,
                trigger: trigger
            )
            center.add(request)
        }
    }

    // MARK: - 設定の保存（UC 32）

    func saveSettings() {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: settingsKey)
        }
    }

    // MARK: - 設定変更ヘルパー（UC 39-44）

    func toggleAnniversary(_ enabled: Bool) {
        settings.isAnniversaryEnabled = enabled
        rescheduleAll()
    }

    func toggleTrendReminder(_ enabled: Bool) {
        settings.isTrendReminderEnabled = enabled
        rescheduleAll()
    }

    func togglePeriodicReminder(_ enabled: Bool) {
        settings.isPeriodicReminderEnabled = enabled
        rescheduleAll()
    }

    func setNotificationTime(hour: Int, minute: Int) {
        settings.notificationHour = hour
        settings.notificationMinute = minute
        rescheduleAll()
    }

    func setPeriodicWeekdays(_ weekdays: Set<Int>) {
        settings.periodicReminderWeekdays = weekdays
        rescheduleAll()
    }

    func setLookbackYears(_ years: [Int]) {
        settings.lookbackYears = years
        rescheduleAll()
    }
}
