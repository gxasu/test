import Foundation

/// 天気データ — その日の気象情報（UC 18-20）
struct WeatherData: Codable, Equatable {
    var condition: WeatherCondition
    var temperatureHigh: Double
    var temperatureLow: Double
    var locationName: String
    var fetchedAt: Date

    enum WeatherCondition: String, Codable, CaseIterable {
        case sunny      = "sunny"
        case cloudy     = "cloudy"
        case rainy      = "rainy"
        case snowy      = "snowy"
        case stormy     = "stormy"
        case partlyCloudy = "partly_cloudy"

        var symbol: String {
            switch self {
            case .sunny:        return "sun.max.fill"
            case .cloudy:       return "cloud.fill"
            case .rainy:        return "cloud.rain.fill"
            case .snowy:        return "cloud.snow.fill"
            case .stormy:       return "cloud.bolt.fill"
            case .partlyCloudy: return "cloud.sun.fill"
            }
        }

        var displayName: String {
            switch self {
            case .sunny:        return "晴れ"
            case .cloudy:       return "曇り"
            case .rainy:        return "雨"
            case .snowy:        return "雪"
            case .stormy:       return "嵐"
            case .partlyCloudy: return "晴れ時々曇り"
            }
        }
    }
}
