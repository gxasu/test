import SwiftUI

/// キャンバス背景選択画面（UC 17, 29）
struct CanvasBackgroundPickerView: View {
    var themeManager: ThemeManager

    var body: some View {
        List(CanvasBackground.allCases) { bg in
            Button(action: { themeManager.setCanvasBackground(bg) }) {
                HStack {
                    // プレビュー
                    CanvasBackgroundView(background: bg)
                        .frame(width: 50, height: 50)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )

                    Text(bg.displayName)
                        .foregroundStyle(.primary)
                        .padding(.leading, 8)

                    Spacer()

                    if themeManager.theme.canvasBackground == bg {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.accentColor)
                    }
                }
            }
        }
        .navigationTitle("キャンバス背景")
    }
}
