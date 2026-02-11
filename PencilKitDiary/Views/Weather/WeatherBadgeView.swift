import SwiftUI

/// 天気バッジ表示 — その日の天気を確認する（UC 18）
struct WeatherBadgeView: View {
    let weather: WeatherData

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: weather.condition.symbol)
                .font(.title3)
                .symbolRenderingMode(.multicolor)

            VStack(alignment: .leading, spacing: 2) {
                Text(weather.condition.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)

                HStack(spacing: 4) {
                    Text("H: \(Int(weather.temperatureHigh))°")
                    Text("L: \(Int(weather.temperatureLow))°")
                        .foregroundStyle(.secondary)
                }
                .font(.caption)
            }

            Spacer()

            Text(weather.locationName)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    WeatherBadgeView(weather: PreviewSampleData.sampleWeather)
        .padding()
}
