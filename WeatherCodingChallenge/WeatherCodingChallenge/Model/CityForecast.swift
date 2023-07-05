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
}
