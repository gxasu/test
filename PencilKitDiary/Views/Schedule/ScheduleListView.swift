import SwiftUI
import SwiftData

/// 予定一覧 — その日の予定を一覧で確認・追加・削除（UC 21-23）
struct ScheduleListView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var entry: DiaryEntry
    @State private var showAddSheet = false
    @State private var newTitle = ""
    @State private var newStartTime = Date()

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label("予定", systemImage: "calendar")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Button(action: { showAddSheet = true }) {
                    Image(systemName: "plus.circle")
                        .font(.subheadline)
                }
            }

            // 予定リスト（UC 21）
            ForEach(entry.schedules) { schedule in
                HStack {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 6, height: 6)

                    Text(schedule.startTime, style: .time)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(schedule.title)
                        .font(.callout)

                    Spacer()

                    // 削除（UC 23）
                    Button(action: { deleteSchedule(schedule) }) {
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
        .alert("予定を追加", isPresented: $showAddSheet) {
            TextField("タイトル", text: $newTitle)
            Button("追加") { addSchedule() }
            Button("キャンセル", role: .cancel) {}
        }
    }

    /// 予定の追加（UC 22）
    private func addSchedule() {
        guard !newTitle.isEmpty else { return }
        let schedule = Schedule(title: newTitle, startTime: newStartTime, diaryEntry: entry)
        modelContext.insert(schedule)
        newTitle = ""
    }

    /// 予定の削除（UC 23）
    private func deleteSchedule(_ schedule: Schedule) {
        modelContext.delete(schedule)
    }
}
