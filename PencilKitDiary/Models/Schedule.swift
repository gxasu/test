import Foundation
import SwiftData

/// 予定 — カレンダーイベント（UC 21-23）
@Model
final class Schedule {
    var title: String
    var startTime: Date
    var endTime: Date?
    var diaryEntry: DiaryEntry?

    init(title: String, startTime: Date, endTime: Date? = nil, diaryEntry: DiaryEntry? = nil) {
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.diaryEntry = diaryEntry
    }
}
