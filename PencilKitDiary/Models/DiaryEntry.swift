import Foundation
import SwiftData
import PencilKit

/// 日記エントリ — 日付ごとの記録単位（UC 1-3, 31）
@Model
final class DiaryEntry {
    /// 日付（時刻を切り捨てた日単位）
    @Attribute(.unique) var date: Date
    /// PencilKit 描画データ（Data にシリアライズして保存）
    var drawingData: Data
    /// メモ（テキスト入力による記録）
    var memo: String
    /// キャンバス背景の種類
    var canvasBackground: CanvasBackground
    /// 天気データ（JSON）
    var weatherJSON: Data?
    /// 作成日時
    var createdAt: Date
    /// 更新日時
    var updatedAt: Date

    // MARK: - Relationships

    /// この日記に紐づくハッシュタグ
    @Relationship(deleteRule: .cascade, inverse: \Hashtag.diaryEntry)
    var hashtags: [Hashtag]

    /// この日記に紐づく予定
    @Relationship(deleteRule: .cascade, inverse: \Schedule.diaryEntry)
    var schedules: [Schedule]

    /// この日記に紐づくリマインダー
    @Relationship(deleteRule: .cascade, inverse: \ReminderItem.diaryEntry)
    var reminders: [ReminderItem]

    init(
        date: Date,
        drawingData: Data = Data(),
        memo: String = "",
        canvasBackground: CanvasBackground = .plain,
        weatherJSON: Data? = nil
    ) {
        let calendar = Calendar.current
        self.date = calendar.startOfDay(for: date)
        self.drawingData = drawingData
        self.memo = memo
        self.canvasBackground = canvasBackground
        self.weatherJSON = weatherJSON
        self.createdAt = Date()
        self.updatedAt = Date()
        self.hashtags = []
        self.schedules = []
        self.reminders = []
    }

    // MARK: - PencilKit 変換ヘルパー

    /// Data → PKDrawing
    var drawing: PKDrawing {
        get {
            (try? PKDrawing(data: drawingData)) ?? PKDrawing()
        }
        set {
            drawingData = newValue.dataRepresentation()
            updatedAt = Date()
        }
    }
}
