import Foundation

/// 通知設定 — 各種通知のON/OFF・時刻などのカスタマイズ（UC 39-44）
struct NotificationSettings: Codable, Equatable {
    /// ○年前の日記通知 ON/OFF（UC 39）
    var isAnniversaryEnabled: Bool
    /// 傾向リマインド通知 ON/OFF（UC 40）
    var isTrendReminderEnabled: Bool
    /// 定期リマインド通知 ON/OFF（UC 41）
    var isPeriodicReminderEnabled: Bool
    /// 通知時刻（UC 42）
    var notificationHour: Int
    var notificationMinute: Int
    /// 定期リマインドの曜日（UC 43） — 1=日, 2=月, ..., 7=土
    var periodicReminderWeekdays: Set<Int>
    /// 振り返る年数（UC 44）
    var lookbackYears: [Int]

    static let `default` = NotificationSettings(
        isAnniversaryEnabled: true,
        isTrendReminderEnabled: false,
        isPeriodicReminderEnabled: true,
        notificationHour: 21,
        notificationMinute: 0,
        periodicReminderWeekdays: [1, 2, 3, 4, 5, 6, 7],
        lookbackYears: [1]
    )
}
