import Foundation
import SwiftUI

/// テーマ管理 — アプリの見た目設定の保存・復元（UC 28-29, 32）
@Observable
final class ThemeManager {
    var theme: Theme

    private let storageKey = "appTheme"

    init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode(Theme.self, from: data) {
            self.theme = saved
        } else {
            self.theme = .default
        }
    }

    /// アクセントカラーを変更（UC 28）
    func setAccentColor(_ color: Theme.AccentColorOption) {
        theme.accentColorName = color
        save()
    }

    /// キャンバス背景を変更（UC 29）
    func setCanvasBackground(_ background: CanvasBackground) {
        theme.canvasBackground = background
        save()
    }

    /// 設定を自動保存（UC 32）
    private func save() {
        if let data = try? JSONEncoder().encode(theme) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
