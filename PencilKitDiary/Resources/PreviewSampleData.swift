import SwiftUI
import SwiftData

/// プレビュー用のサンプルデータとModelContainer
enum PreviewSampleData {

    /// インメモリの ModelContainer（プレビュー用）
    static var container: ModelContainer {
        let schema = Schema([DiaryEntry.self, Hashtag.self, Schedule.self, ReminderItem.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: config)

        // サンプルデータを挿入
        let context = container.mainContext
        let entry = DiaryEntry(date: Date(), memo: "今日は #旅行 で京都に行った。とても #楽しい 一日だった。")
        context.insert(entry)

        let tag1 = Hashtag(name: "旅行", diaryEntry: entry)
        let tag2 = Hashtag(name: "楽しい", diaryEntry: entry)
        context.insert(tag1)
        context.insert(tag2)

        let schedule = Schedule(title: "京都観光", startTime: Date(), diaryEntry: entry)
        context.insert(schedule)

        let reminder1 = ReminderItem(title: "お土産を買う", isCompleted: true, diaryEntry: entry)
        let reminder2 = ReminderItem(title: "写真を整理する", isCompleted: false, diaryEntry: entry)
        context.insert(reminder1)
        context.insert(reminder2)

        return container
    }

    static var sampleWeather: WeatherData {
        WeatherData(
            condition: .sunny,
            temperatureHigh: 28.0,
            temperatureLow: 19.0,
            locationName: "東京",
            fetchedAt: Date()
        )
    }
}
