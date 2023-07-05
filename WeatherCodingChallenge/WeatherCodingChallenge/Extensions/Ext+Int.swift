//
//  Ext+Int.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/5/23.
//

import Foundation

extension Int {
    // This custom extension corresponds to the Int values provided by the Weather API
    // Based on the range of values, it will return a SFSymbol string to be used with a SwiftUI Image and UIImageViews
    func createCurrentConditions() -> String {
        switch self {
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
