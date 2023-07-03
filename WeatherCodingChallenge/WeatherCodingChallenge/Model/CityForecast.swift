//
//  CityForecast.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/3/23.
//

import Foundation

struct CityForecast {
    let cityName: String
    let temp: Double
    let feelsLike: Double
    let tempLow: Double
    let tempHigh: Double
    let conditionsDescription: String
    let conditionsID: Int
    
    var currentConditions: String {
        switch conditionsID {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        default:
            return "cloud"
        }
    }
}
