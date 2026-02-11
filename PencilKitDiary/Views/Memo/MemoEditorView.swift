import SwiftUI
import SwiftData

/// メモ編集ビュー — テキスト入力とハッシュタグ表示（UC 7-8, 10）
struct MemoEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var entry: DiaryEntry
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("メモ")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // テキスト入力（UC 7）
            TextEditor(text: $entry.memo)
                .frame(minHeight: 100)
                .padding(8)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .focused($isFocused)
                .onChange(of: entry.memo) {
                    // ハッシュタグの自動認識と同期（UC 9, 12）
                    HashtagParser.syncHashtags(for: entry, in: modelContext)
                    entry.updatedAt = Date()
                }

            // ハッシュタグ表示（UC 10）
            if !entry.hashtags.isEmpty {
                HashtagFlowView(hashtags: entry.hashtags.map(\.name))
            }
        }
    }
}
