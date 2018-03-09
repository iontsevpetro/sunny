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
    
    // keys for API access
    struct WeatherKeys {
        static let temperature = "temperature"
        static let summary = "summary"
    }
    
    init(weatherDictionary: [String: Any]) {
        summary = weatherDictionary[WeatherKeys.summary] as? String
        //here do fahrenheit to celcius convertion
        if let tempDouble = weatherDictionary[WeatherKeys.temperature] as? Double {
            temperature = Int((tempDouble - 32) / 1.8)
        } else {
            temperature = nil
        }
    }
}

