import SwiftUI

/// 日付選択シート — 過去の日記を日付指定で開く（UC 2）
struct DiaryDatePickerView: View {
    @Environment(\.dismiss) private var dismiss
    var diaryStore: DiaryStore
    @State private var selectedDate = Date()

    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "日付を選択",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale(identifier: "ja_JP"))
                .padding()

                Spacer()
            }
            .navigationTitle("日付を選択")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("開く") {
                        diaryStore.goToDate(selectedDate)
                        dismiss()
                    }
                }
            }
        }
    }
}
