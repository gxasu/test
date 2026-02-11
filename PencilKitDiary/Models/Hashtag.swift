import Foundation
import SwiftData

/// ハッシュタグ — メモ内の # から始まるキーワード（UC 8-12）
@Model
final class Hashtag {
    /// タグ名（# を除いた文字列）
    var name: String
    /// 紐づく日記
    var diaryEntry: DiaryEntry?

    init(name: String, diaryEntry: DiaryEntry? = nil) {
        self.name = name
        self.diaryEntry = diaryEntry
    }
}
