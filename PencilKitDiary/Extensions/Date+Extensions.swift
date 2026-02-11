import Foundation

extension Date {
    /// 日付の表示用フォーマット（例: "2025年5月14日（水）"）
    var diaryDisplayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月d日（E）"
        return formatter.string(from: self)
    }

    /// 短い日付表示（例: "5/14"）
    var shortDisplayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M/d"
        return formatter.string(from: self)
    }

    /// 日単位の開始時刻を返す
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// 指定日数を加算した日付
    func adding(days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
}
