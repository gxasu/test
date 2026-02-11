import SwiftUI

/// アクセントカラー選択画面（UC 28）
struct ThemeColorPickerView: View {
    var themeManager: ThemeManager

    var body: some View {
        List(Theme.AccentColorOption.allCases) { option in
            Button(action: { themeManager.setAccentColor(option) }) {
                HStack {
                    Circle()
                        .fill(option.color)
                        .frame(width: 24, height: 24)

                    Text(option.displayName)
                        .foregroundStyle(.primary)

                    Spacer()

                    if themeManager.theme.accentColorName == option {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.accentColor)
                    }
                }
            }
        }
        .navigationTitle("アクセントカラー")
    }
}
