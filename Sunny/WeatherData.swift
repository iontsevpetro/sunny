//
//  WeatherData.swift
//  Sunny
//
//  Created by Peter Iontsev on 2/25/18.
//  Copyright © 2018 Peter Iontsev. All rights reserved.
//

import Foundation

class Weather {
    
    let temperature: Int?
    let summary: String?
    let icon: String?
    
    // keys for API access
    struct WeatherKeys {
        static let temperature = "temperature"
        static let summary = "summary"
        static let icon = "icon"
    }
    init(weatherDictionary: [String: Any]) {
        summary = weatherDictionary[WeatherKeys.summary] as? String
        let iconString = weatherDictionary[WeatherKeys.icon] as? String
        icon = weatherIconFormString(stringIcon: iconString!)
        //here do fahrenheit to celcius convertion
        if let tempDouble = weatherDictionary[WeatherKeys.temperature] as? Double {
            temperature = Int((tempDouble - 32) / 1.8)
        } else {
            temperature = nil
        }
    }
}

func weatherIconFormString(stringIcon: String) -> String? {
    var iconImage: String
    switch stringIcon {
    case "clear-day":
        iconImage = "☀️"
    case "clear-night":
        iconImage = "🌖"
    case "rain":
        iconImage = "🌧"
    case "snow":
        iconImage = "❄️"
    case "sleet":
        iconImage = "🌨"
    case "wind":
        iconImage = "🌬"
    case "fog":
        iconImage = "🌫"
    case "cloudy":
        iconImage = "☁️"
    case "partly-cloudy-day":
        iconImage = "⛅️"
    case "partly-cloudy-night":
        iconImage = "🌒"
    default:
        iconImage = "No data"
    }
    return iconImage
}

