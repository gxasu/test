import Foundation
import SwiftData

/// リマインダー — タスク・ToDo（UC 24-27）
@Model
final class ReminderItem {
    var title: String
    var isCompleted: Bool
    var diaryEntry: DiaryEntry?

    init(title: String, isCompleted: Bool = false, diaryEntry: DiaryEntry? = nil) {
        self.title = title
        self.isCompleted = isCompleted
        self.diaryEntry = diaryEntry
    }
}
