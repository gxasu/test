import SwiftUI
import SwiftData

/// リマインダー一覧 — タスクの確認・追加・完了・削除（UC 24-27）
struct ReminderListView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var entry: DiaryEntry
    @State private var showAddAlert = false
    @State private var newTitle = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label("リマインダー", systemImage: "checklist")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Button(action: { showAddAlert = true }) {
                    Image(systemName: "plus.circle")
                        .font(.subheadline)
                }
            }

            // リマインダーリスト（UC 24）
            ForEach(entry.reminders) { reminder in
                HStack {
                    // 完了/未完了の切り替え（UC 26）
                    Button(action: { toggleCompletion(reminder) }) {
                        Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(reminder.isCompleted ? .green : .secondary)
                    }

                    Text(reminder.title)
                        .font(.callout)
                        .strikethrough(reminder.isCompleted)
                        .foregroundStyle(reminder.isCompleted ? .secondary : .primary)

                    Spacer()

                    // 削除（UC 27）
                    Button(action: { deleteReminder(reminder) }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .alert("リマインダーを追加", isPresented: $showAddAlert) {
            TextField("タイトル", text: $newTitle)
            Button("追加") { addReminder() }
            Button("キャンセル", role: .cancel) {}
        }
    }

    /// リマインダーの追加（UC 25）
    private func addReminder() {
        guard !newTitle.isEmpty else { return }
        let reminder = ReminderItem(title: newTitle, diaryEntry: entry)
        modelContext.insert(reminder)
        newTitle = ""
    }

    /// 完了/未完了の切り替え（UC 26）
    private func toggleCompletion(_ reminder: ReminderItem) {
        reminder.isCompleted.toggle()
    }

    /// リマインダーの削除（UC 27）
    private func deleteReminder(_ reminder: ReminderItem) {
        modelContext.delete(reminder)
    }
}
