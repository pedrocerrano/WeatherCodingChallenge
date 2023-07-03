//
//  Forecast.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/3/23.
//

import Foundation

struct Forecast: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case details = "main"
        case current = "weather"
    }
    
    let name: String
    let details: Details
    let current: [CurrentConditions]
}

struct Details: Codable {
    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case low       = "temp_min"
        case high      = "temp_high"
    }
    
    let temp: Double
    let feelsLike: Double
    let low: Double
    let high: Double
}

struct CurrentConditions: Codable {
    let description: String
    let id: Int
}


