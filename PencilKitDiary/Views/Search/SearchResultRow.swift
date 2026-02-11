import SwiftUI

/// 検索結果の行表示（UC 15）
struct SearchResultRow: View {
    let entry: DiaryEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.date.diaryDisplayString)
                .font(.subheadline)
                .fontWeight(.medium)

            if !entry.memo.isEmpty {
                Text(entry.memo)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            if !entry.hashtags.isEmpty {
                HStack(spacing: 4) {
                    ForEach(entry.hashtags.prefix(5)) { tag in
                        Text("#\(tag.name)")
                            .font(.caption2)
                            .foregroundStyle(.accentColor)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
