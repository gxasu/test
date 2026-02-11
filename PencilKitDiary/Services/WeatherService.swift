import Foundation

/// 天気サービス — 天気データの取得とキャッシュ（UC 18-20）
@Observable
final class WeatherService {
    private var cache: [String: WeatherData] = [:]
    private let cacheExpiry: TimeInterval = 3600 // 1時間

    /// 指定場所の天気を取得する（UC 19）
    /// キャッシュがあればキャッシュから返す（UC 20）
    func fetchWeather(for locationName: String) async -> WeatherData? {
        // キャッシュチェック（UC 20）
        let cacheKey = cacheKey(for: locationName)
        if let cached = cache[cacheKey], !isCacheExpired(cached) {
            return cached
        }

        // 実際の天気 API 呼び出し（プレースホルダー実装）
        // 本番では OpenWeatherMap 等の API を使用
        let weather = await fetchFromAPI(locationName: locationName)

        if let weather {
            cache[cacheKey] = weather
        }
        return weather
    }

    // MARK: - Private

    private func cacheKey(for location: String) -> String {
        let dateStr = ISO8601DateFormatter().string(from: Calendar.current.startOfDay(for: Date()))
        return "\(location)_\(dateStr)"
    }

    private func isCacheExpired(_ data: WeatherData) -> Bool {
        Date().timeIntervalSince(data.fetchedAt) > cacheExpiry
    }

    /// API 呼び出しプレースホルダー
    private func fetchFromAPI(locationName: String) async -> WeatherData? {
        // TODO: 実際の天気 API に接続する
        // ここではデモデータを返す
        return WeatherData(
            condition: .sunny,
            temperatureHigh: 25.0,
            temperatureLow: 18.0,
            locationName: locationName,
            fetchedAt: Date()
        )
    }
}
