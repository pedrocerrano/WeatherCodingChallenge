//
//  FiveDayWeather.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/4/23.
//

import Foundation

struct FiveDayWeather: Codable {
    let list: [ThreeHourFutureWeather]
}

struct ThreeHourFutureWeather: Codable {
    private enum CodingKeys: String, CodingKey {
        case date             = "dt_txt"
        case main
        case futureConditions = "weather"
        case precipitation    = "pop"
    }
    
    let date: String
    let main: ThreeHourFutureTemp
    let futureConditions: [ThreeHourFutureConditions]
    let precipitation: Double
}

struct ThreeHourFutureTemp: Codable {
    
    // I named these low and high to differientate between the CityForecast lowTemp and highTemp
    // An attempt to improve readability
    private enum CodingKeys: String, CodingKey {
        case low       = "temp_min"
        case high      = "temp_max"
    }
    
    let low: Double
    let high: Double
}

struct ThreeHourFutureConditions: Codable {
    let id: Int
}
