//
//  CityForecast.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/3/23.
//

import Foundation

struct CityForecast: Codable {
    
    // This model complies the JSON data into one easy-to-use and object.
    // Improves readability
    let cityName: String
    let temp: Double
    let feelsLike: Double
    let tempLow: Double
    let tempHigh: Double
    let conditionsDescription: String
    let conditionsID: Int
}
