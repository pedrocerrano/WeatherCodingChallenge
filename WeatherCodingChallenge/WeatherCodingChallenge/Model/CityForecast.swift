//
//  CityForecast.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/3/23.
//

import Foundation

struct CityForecast: Codable {
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
            return WeatherSFSymbols.thunderstorm
        case 300...321:
            return WeatherSFSymbols.drizzle
        case 500...531:
            return WeatherSFSymbols.rainy
        case 600...622:
            return WeatherSFSymbols.snowy
        case 701...781:
            return WeatherSFSymbols.foggy
        case 800:
            return WeatherSFSymbols.sunny
        default:
            return WeatherSFSymbols.cloudy
        }
    }
}
