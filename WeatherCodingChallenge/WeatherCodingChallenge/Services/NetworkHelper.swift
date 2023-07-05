//
//  NetworkHelper.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/5/23.
//

import Foundation

struct NetworkHelper {
    
    // These functions convert the messy API JSON into a simple-to-use Model for the respective functions within the NetworkService. They're called on the return's of the do { }.
    static func createCityForecast(_ weather: Weather) -> CityForecast {
        return CityForecast(cityName: weather.cityName,
                            temp: weather.details.temp,
                            feelsLike: weather.details.feelsLike,
                            tempLow: weather.details.low,
                            tempHigh: weather.details.high,
                            conditionsDescription: weather.conditions[0].description,
                            conditionsID: weather.conditions[0].id)
    }
    
    static func createThreeHourForecast(_ fiveDayWeather: FiveDayWeather) -> [ThreeHourForecast] {
        var fiveDayForecastArray: [ThreeHourForecast] = []
        for dailyWeather in fiveDayWeather.list {
            let dailyForecast = ThreeHourForecast(time: dailyWeather.date.convertToTime(),
                                                  chances: dailyWeather.precipitation,
                                                  conditionsID: dailyWeather.futureConditions[0].id,
                                                  tempLow: dailyWeather.main.low,
                                                  tempHigh: dailyWeather.main.high)
            fiveDayForecastArray.append(dailyForecast)
        }
        
        return fiveDayForecastArray
    }
}
