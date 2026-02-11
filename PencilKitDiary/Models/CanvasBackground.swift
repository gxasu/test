import Foundation

/// キャンバス背景 — 手書きエリアの背景パターン（UC 17, 29）
enum CanvasBackground: String, Codable, CaseIterable, Identifiable {
    case plain    = "plain"     // 無地
    case grid     = "grid"      // 方眼紙
    case dot      = "dot"       // ドット
    case ruled    = "ruled"     // 罫線

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .plain: return "無地"
        case .grid:  return "方眼紙"
        case .dot:   return "ドット"
        case .ruled: return "罫線"
        }
    }
}
