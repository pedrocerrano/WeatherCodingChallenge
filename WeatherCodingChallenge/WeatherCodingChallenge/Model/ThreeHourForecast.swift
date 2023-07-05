//
//  ThreeHourForecast.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/4/23.
//

import Foundation

struct ThreeHourForecast: Codable {
    
    let time: String
    let chances: Double
    let conditionsID: Int
    let tempLow: Double
    let tempHigh: Double
}
