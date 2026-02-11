import Foundation
import SwiftData

/// ハッシュタグ解析 — メモ内の # タグを自動認識（UC 9, 12）
struct HashtagParser {
    /// メモ文字列からハッシュタグ名を抽出する
    /// 例: "今日は #旅行 に行った #楽しい" → ["旅行", "楽しい"]
    static func parse(_ text: String) -> [String] {
        // Unicode 対応: # の後に1文字以上の単語文字（日本語含む）
        let pattern = #"#([\p{L}\p{N}_]+)"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        let range = NSRange(text.startIndex..., in: text)
        let matches = regex.matches(in: text, range: range)

        return matches.compactMap { match in
            guard let tagRange = Range(match.range(at: 1), in: text) else { return nil }
            return String(text[tagRange])
        }
    }

    /// 日記エントリのメモからハッシュタグを同期する（UC 9, 12）
    /// 既存のタグとの差分を取り、追加・削除を行う
    static func syncHashtags(for entry: DiaryEntry, in context: ModelContext) {
        let parsed = Set(parse(entry.memo))
        let existing = Set(entry.hashtags.map(\.name))

        // 新規タグの追加
        for name in parsed.subtracting(existing) {
            let tag = Hashtag(name: name, diaryEntry: entry)
            context.insert(tag)
        }

        // 削除されたタグの除去
        for tag in entry.hashtags where !parsed.contains(tag.name) {
            context.delete(tag)
        }
    }
}
