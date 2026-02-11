import SwiftUI

/// 設定画面 — テーマ・場所・通知設定のハブ（UC 28-30, 39-44）
struct SettingsView: View {
    var themeManager: ThemeManager
    var notificationManager: NotificationManager
    @State private var locationName: String = UserDefaults.standard.string(forKey: "weatherLocation") ?? "東京"

    var body: some View {
        NavigationStack {
            Form {
                // テーマ設定（UC 28-29）
                Section("テーマ") {
                    NavigationLink("アクセントカラー") {
                        ThemeColorPickerView(themeManager: themeManager)
                    }
                    NavigationLink("キャンバス背景") {
                        CanvasBackgroundPickerView(themeManager: themeManager)
                    }
                }

                // 場所設定（UC 30）
                Section("天気") {
                    HStack {
                        Text("場所")
                        Spacer()
                        TextField("都市名", text: $locationName)
                            .multilineTextAlignment(.trailing)
                            .onSubmit { saveLocation() }
                    }
                }

                // 通知設定（UC 39-44）
                Section("通知") {
                    NavigationLink("通知設定") {
                        NotificationSettingsView(notificationManager: notificationManager)
                    }
                }
            }
            .navigationTitle("設定")
        }
    }

    private func saveLocation() {
        UserDefaults.standard.set(locationName, forKey: "weatherLocation")
    }
}
