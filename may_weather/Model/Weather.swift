//
//  Weather.swift
//  may_weather
//
//  Created by Grzegorz Bogdan on 29/11/2018.
//  Copyright © 2018 Grzegorz Bogdan. All rights reserved.
//

import Foundation

struct Weather: Codable {
    
    var locationName: String? // risky?
    let latitude: Double
    let longitude: Double
    let daily: WeatherData
    let currently: Currently
    
    struct Currently: Codable {
        let temperature: Double
    }
    
    struct WeatherData: Codable {
        let data: [WeatherDayData]
    }
    
    struct WeatherDayData: Codable {
        let time: Int32
        let summary: String
        let icon: String
        let precipProbability: Double
        let pressure: Double
        let windSpeed: Double
        let windBearing: Double
        let temperatureMin: Double
        let temperatureMax: Double
    }
}
