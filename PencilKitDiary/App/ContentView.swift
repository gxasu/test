import SwiftUI
import SwiftData

/// メインコンテンツ — タブ切り替えで日記・検索・設定を表示
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var diaryStore: DiaryStore?
    @State private var selectedTab: Tab = .diary

    var themeManager: ThemeManager
    var notificationManager: NotificationManager
    var weatherService: WeatherService

    enum Tab {
        case diary, search, settings
    }

    var body: some View {
        Group {
            if let diaryStore {
                TabView(selection: $selectedTab) {
                    // 日記タブ（UC 1-7）
                    NavigationStack {
                        DiaryView(
                            entry: diaryStore.entry(for: diaryStore.selectedDate),
                            diaryStore: diaryStore,
                            weatherService: weatherService,
                            themeManager: themeManager
                        )
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("今日", action: { diaryStore.goToToday() })
                            }
                        }
                    }
                    .tabItem {
                        Label("日記", systemImage: "book.fill")
                    }
                    .tag(Tab.diary)

                    // 検索タブ（UC 13-16）
                    SearchView(diaryStore: diaryStore)
                        .tabItem {
                            Label("検索", systemImage: "magnifyingglass")
                        }
                        .tag(Tab.search)

                    // 設定タブ（UC 28-30, 39-44）
                    SettingsView(
                        themeManager: themeManager,
                        notificationManager: notificationManager
                    )
                    .tabItem {
                        Label("設定", systemImage: "gearshape.fill")
                    }
                    .tag(Tab.settings)
                }
            } else {
                ProgressView("読み込み中…")
            }
        }
        .onAppear {
            diaryStore = DiaryStore(modelContext: modelContext)
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView(
        themeManager: ThemeManager(),
        notificationManager: NotificationManager(),
        weatherService: WeatherService()
    )
    .modelContainer(PreviewSampleData.container)
}
