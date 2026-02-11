import SwiftUI
import SwiftData
import PencilKit

/// 日記メイン画面 — 手書きキャンバス + メモ + 天気・予定・リマインダー（UC 1-7, 18, 21, 24）
struct DiaryView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var entry: DiaryEntry
    @State private var drawing: PKDrawing = PKDrawing()
    @State private var toolPickerVisible = true
    @State private var showDatePicker = false

    var diaryStore: DiaryStore
    var weatherService: WeatherService
    var themeManager: ThemeManager

    @State private var weather: WeatherData?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 日付ヘッダー
                dateHeader

                // 天気表示（UC 18）
                if let weather {
                    WeatherBadgeView(weather: weather)
                        .padding(.horizontal)
                }

                // 予定一覧（UC 21）
                if !entry.schedules.isEmpty {
                    ScheduleListView(entry: entry)
                        .padding(.horizontal)
                }

                // リマインダー一覧（UC 24）
                if !entry.reminders.isEmpty {
                    ReminderListView(entry: entry)
                        .padding(.horizontal)
                }

                // 手書きキャンバス（UC 4-6）
                ZStack {
                    CanvasBackgroundView(background: entry.canvasBackground)
                    DiaryCanvasView(
                        drawing: $drawing,
                        toolPickerVisible: $toolPickerVisible,
                        background: entry.canvasBackground,
                        onDrawingChanged: saveDrawing
                    )
                }
                .frame(minHeight: 400)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                // メモ入力（UC 7-8）
                MemoEditorView(entry: entry)
                    .padding(.horizontal)
                    .padding(.top, 12)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            drawing = entry.drawing
            Task { await loadWeather() }
        }
        .sheet(isPresented: $showDatePicker) {
            DiaryDatePickerView(diaryStore: diaryStore)
        }
    }

    // MARK: - 日付ヘッダー

    private var dateHeader: some View {
        HStack {
            Button(action: { diaryStore.goToDate(entry.date.adding(days: -1)) }) {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Button(action: { showDatePicker = true }) {
                Text(entry.date.diaryDisplayString)
                    .font(.headline)
            }

            Spacer()

            Button(action: { diaryStore.goToDate(entry.date.adding(days: 1)) }) {
                Image(systemName: "chevron.right")
            }
        }
        .padding()
    }

    // MARK: - 保存

    private func saveDrawing() {
        entry.drawing = drawing
        diaryStore.save()
    }

    private func loadWeather() async {
        // 天気データの取得（UC 19）
        weather = await weatherService.fetchWeather(for: "東京")
        if let weather, let data = try? JSONEncoder().encode(weather) {
            entry.weatherJSON = data
            diaryStore.save()
        }
    }
}
