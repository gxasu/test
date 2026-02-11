import SwiftUI

/// 通知設定画面（UC 39-44）
struct NotificationSettingsView: View {
    var notificationManager: NotificationManager

    private let weekdayNames = ["日", "月", "火", "水", "木", "金", "土"]

    var body: some View {
        Form {
            // ○年前の日記通知（UC 39）
            Section("ふりかえり通知") {
                Toggle(
                    "○年前の日記通知",
                    isOn: Binding(
                        get: { notificationManager.settings.isAnniversaryEnabled },
                        set: { notificationManager.toggleAnniversary($0) }
                    )
                )

                // 振り返る年数（UC 44）
                if notificationManager.settings.isAnniversaryEnabled {
                    NavigationLink("振り返る年数") {
                        LookbackYearsView(notificationManager: notificationManager)
                    }
                }
            }

            // 傾向リマインド通知（UC 40）
            Section("傾向リマインド") {
                Toggle(
                    "傾向リマインド通知",
                    isOn: Binding(
                        get: { notificationManager.settings.isTrendReminderEnabled },
                        set: { notificationManager.toggleTrendReminder($0) }
                    )
                )
            }

            // 定期リマインド通知（UC 41, 43）
            Section("定期リマインド") {
                Toggle(
                    "定期リマインド通知",
                    isOn: Binding(
                        get: { notificationManager.settings.isPeriodicReminderEnabled },
                        set: { notificationManager.togglePeriodicReminder($0) }
                    )
                )

                // 曜日選択（UC 43）
                if notificationManager.settings.isPeriodicReminderEnabled {
                    HStack {
                        ForEach(1...7, id: \.self) { weekday in
                            let isSelected = notificationManager.settings.periodicReminderWeekdays.contains(weekday)
                            Button(action: { toggleWeekday(weekday) }) {
                                Text(weekdayNames[weekday - 1])
                                    .font(.caption)
                                    .frame(width: 32, height: 32)
                                    .background(isSelected ? Color.accentColor : Color(.systemGray5))
                                    .foregroundStyle(isSelected ? .white : .primary)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
            }

            // 通知時刻（UC 42）
            Section("通知時刻") {
                DatePicker(
                    "時刻",
                    selection: notificationTimeBinding,
                    displayedComponents: .hourAndMinute
                )
            }
        }
        .navigationTitle("通知設定")
    }

    private var notificationTimeBinding: Binding<Date> {
        Binding(
            get: {
                var components = DateComponents()
                components.hour = notificationManager.settings.notificationHour
                components.minute = notificationManager.settings.notificationMinute
                return Calendar.current.date(from: components) ?? Date()
            },
            set: { date in
                let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                notificationManager.setNotificationTime(
                    hour: components.hour ?? 21,
                    minute: components.minute ?? 0
                )
            }
        )
    }

    private func toggleWeekday(_ weekday: Int) {
        var weekdays = notificationManager.settings.periodicReminderWeekdays
        if weekdays.contains(weekday) {
            weekdays.remove(weekday)
        } else {
            weekdays.insert(weekday)
        }
        notificationManager.setPeriodicWeekdays(weekdays)
    }
}

/// 振り返り年数選択画面（UC 44）
struct LookbackYearsView: View {
    var notificationManager: NotificationManager

    var body: some View {
        List(1...10, id: \.self) { year in
            let isSelected = notificationManager.settings.lookbackYears.contains(year)
            Button(action: { toggleYear(year) }) {
                HStack {
                    Text("\(year)年前")
                        .foregroundStyle(.primary)
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.accentColor)
                    }
                }
            }
        }
        .navigationTitle("振り返る年数")
    }

    private func toggleYear(_ year: Int) {
        var years = notificationManager.settings.lookbackYears
        if let index = years.firstIndex(of: year) {
            years.remove(at: index)
        } else {
            years.append(year)
            years.sort()
        }
        notificationManager.setLookbackYears(years)
    }
}

#Preview {
    NavigationStack {
        NotificationSettingsView(notificationManager: NotificationManager())
    }
}
