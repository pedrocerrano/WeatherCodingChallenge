//
//  Weather.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/3/23.
//

import Foundation

struct Weather: Codable {
    private enum CodingKeys: String, CodingKey {
        case cityName   = "name"
        case details    = "main"
        case conditions = "weather"
    }
    
    let cityName: String
    let details: WeatherDetails
    let conditions: [WeatherConditions]
}

struct WeatherDetails: Codable {
    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case low       = "temp_min"
        case high      = "temp_max"
    }
    
    let temp: Double
    let feelsLike: Double
    let low: Double
    let high: Double
}

struct WeatherConditions: Codable {
    let description: String
    let id: Int
}


