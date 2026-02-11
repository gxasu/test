import SwiftUI

/// テーマ — アプリの見た目設定（UC 28-29, 32）
struct Theme: Codable, Equatable {
    var accentColorName: AccentColorOption
    var canvasBackground: CanvasBackground

    static let `default` = Theme(
        accentColorName: .blue,
        canvasBackground: .plain
    )

    enum AccentColorOption: String, Codable, CaseIterable, Identifiable {
        case blue, purple, pink, orange, green, red

        var id: String { rawValue }

        var color: Color {
            switch self {
            case .blue:   return .blue
            case .purple: return .purple
            case .pink:   return .pink
            case .orange: return .orange
            case .green:  return .green
            case .red:    return .red
            }
        }

        var displayName: String {
            switch self {
            case .blue:   return "ブルー"
            case .purple: return "パープル"
            case .pink:   return "ピンク"
            case .orange: return "オレンジ"
            case .green:  return "グリーン"
            case .red:    return "レッド"
            }
        }
    }
}
