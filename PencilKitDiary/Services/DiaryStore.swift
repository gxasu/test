import Foundation
import SwiftData
import SwiftUI

/// 日記データの永続化・検索を担うストア（UC 1-3, 13-16, 31）
@Observable
final class DiaryStore {
    private let modelContext: ModelContext

    /// 現在表示中の日付
    var selectedDate: Date

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.selectedDate = Calendar.current.startOfDay(for: Date())
    }

    // MARK: - 日記の取得・作成（UC 1-3）

    /// 指定日の日記を取得。なければ新規作成して返す
    func entry(for date: Date) -> DiaryEntry {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let predicate = #Predicate<DiaryEntry> { entry in
            entry.date == startOfDay
        }
        var descriptor = FetchDescriptor<DiaryEntry>(predicate: predicate)
        descriptor.fetchLimit = 1

        if let existing = try? modelContext.fetch(descriptor).first {
            return existing
        }

        let newEntry = DiaryEntry(date: startOfDay)
        modelContext.insert(newEntry)
        save()
        return newEntry
    }

    /// 今日の日記に戻る（UC 3）
    func goToToday() {
        selectedDate = Calendar.current.startOfDay(for: Date())
    }

    /// 過去の日記を日付指定で開く（UC 2）
    func goToDate(_ date: Date) {
        selectedDate = Calendar.current.startOfDay(for: date)
    }

    // MARK: - 検索（UC 13-16）

    /// キーワードでメモを検索（UC 13）
    func searchByKeyword(_ keyword: String) -> [DiaryEntry] {
        let predicate = #Predicate<DiaryEntry> { entry in
            entry.memo.localizedStandardContains(keyword)
        }
        let descriptor = FetchDescriptor<DiaryEntry>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    /// ハッシュタグで日記を絞り込む（UC 14, 16）
    func searchByHashtag(_ tagName: String) -> [DiaryEntry] {
        let predicate = #Predicate<Hashtag> { tag in
            tag.name == tagName
        }
        let descriptor = FetchDescriptor<Hashtag>(predicate: predicate)
        let tags = (try? modelContext.fetch(descriptor)) ?? []
        return tags.compactMap(\.diaryEntry).sorted { $0.date > $1.date }
    }

    /// 全ハッシュタグを使用頻度順で取得（UC 11）
    func allHashtags() -> [(name: String, count: Int)] {
        let descriptor = FetchDescriptor<Hashtag>()
        let tags = (try? modelContext.fetch(descriptor)) ?? []
        var frequency: [String: Int] = [:]
        for tag in tags {
            frequency[tag.name, default: 0] += 1
        }
        return frequency.map { (name: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
    }

    // MARK: - ふりかえり（UC 33-35）

    /// ○年前の今日の日記を取得
    func anniversaryEntries(lookbackYears: [Int]) -> [DiaryEntry] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var entries: [DiaryEntry] = []

        for year in lookbackYears {
            guard let pastDate = calendar.date(byAdding: .year, value: -year, to: today) else { continue }
            let predicate = #Predicate<DiaryEntry> { entry in
                entry.date == pastDate
            }
            var descriptor = FetchDescriptor<DiaryEntry>(predicate: predicate)
            descriptor.fetchLimit = 1
            if let entry = try? modelContext.fetch(descriptor).first {
                entries.append(entry)
            }
        }
        return entries
    }

    // MARK: - 保存（UC 31）

    func save() {
        try? modelContext.save()
    }
}
