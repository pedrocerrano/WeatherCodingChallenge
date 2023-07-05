//
//  NetworkService.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/3/23.
//

import Foundation
import CoreLocation

class NetworkService {
    
    //MARK: - Properties
//    static let shared   = NetworkService()
    private let decoder = JSONDecoder()
    
    private let openWeatherURL      = "https://api.openweathermap.org/data/2.5/"
    private let weatherPath         = "weather"
    private let fiveDayForecastPath = "forecast"
    private let appIdKey            = "appid"
    private let appIdValue          = "f915325ff07fd674f190487224e5af9e"
    private let unitTypeKey         = "units"
    private let unitTypeValue       = "imperial"
    
    private let cityNameQueryKey  = "q"
    private let latitudeQueryKey  = "lat"
    private let longitudeQueryKey = "lon"
    
    
    //MARK: - Functions
    func fetchWeatherByCity(forCity city: String) async throws -> CityForecast {
        guard let baseURL = URL(string: openWeatherURL) else { throw WeatherError.invalidURL }
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path.append(weatherPath)
        
        let appIdQuery    = URLQueryItem(name: appIdKey, value: appIdValue)
        let unitTypeQuery = URLQueryItem(name: unitTypeKey, value: unitTypeValue)
        let cityNameQuery = URLQueryItem(name: cityNameQueryKey, value: city)
        urlComponents?.queryItems = [appIdQuery, unitTypeQuery, cityNameQuery]
        
        guard let finalURL = urlComponents?.url else { throw WeatherError.unableToComplete }
        print("SERVICE City Search finalURL: \(finalURL)")
        
        let (data, response) = try await URLSession.shared.data(from: finalURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        do {
            let forecast = try decoder.decode(Weather.self, from: data)
            return createCityForecast(forecast)
        } catch {
            throw WeatherError.invalidData
        }
    }
    
    func fetchWeatherbyLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> CityForecast {
        guard let baseURL = URL(string: openWeatherURL) else { throw WeatherError.invalidURL }
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path.append(weatherPath)
        
        let appIdQuery     = URLQueryItem(name: appIdKey, value: appIdValue)
        let unitTypeQuery  = URLQueryItem(name: unitTypeKey, value: unitTypeValue)
        let latitudeQuery  = URLQueryItem(name: latitudeQueryKey, value: String("\(latitude)"))
        let longitudeQuery = URLQueryItem(name: longitudeQueryKey, value: String("\(longitude)"))
        urlComponents?.queryItems = [appIdQuery, unitTypeQuery, latitudeQuery, longitudeQuery]
        
        guard let finalURL = urlComponents?.url else { throw WeatherError.invalidURL }
        print("SERVICE Location Search finalURL: \(finalURL)")
        
        let (data, response) = try await URLSession.shared.data(from: finalURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        do {
            let forecast = try decoder.decode(Weather.self, from: data)
            return createCityForecast(forecast)
        } catch {
            throw WeatherError.invalidData
        }
    }
    
    private func createCityForecast(_ weather: Weather) -> CityForecast {
        return CityForecast(cityName: weather.cityName,
                            temp: weather.details.temp,
                            feelsLike: weather.details.feelsLike,
                            tempLow: weather.details.low,
                            tempHigh: weather.details.high,
                            conditionsDescription: weather.conditions[0].description,
                            conditionsID: weather.conditions[0].id)
    }
    
    func fetchFiveDayForecastByCity(forCity city: String) async throws -> [ThreeHourForecast] {
        guard let baseURL = URL(string: openWeatherURL) else { throw WeatherError.invalidURL }
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path.append(fiveDayForecastPath)
        
        let appIdQuery    = URLQueryItem(name: appIdKey, value: appIdValue)
        let unitTypeQuery = URLQueryItem(name: unitTypeKey, value: unitTypeValue)
        let cityNameQuery = URLQueryItem(name: cityNameQueryKey, value: city)
        urlComponents?.queryItems = [appIdQuery, unitTypeQuery, cityNameQuery]
        
        guard let finalURL = urlComponents?.url else { throw WeatherError.unableToComplete }
        print("SERVICE 5-day Forecast finalURL: \(finalURL)")
        
        let (data, response) = try await URLSession.shared.data(from: finalURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        do {
            let fiveDayWeather = try decoder.decode(FiveDayWeather.self, from: data)
            return createFiveDayForecast(fiveDayWeather)
        } catch {
            throw WeatherError.invalidData
        }
    }
    
    private func createFiveDayForecast(_ fiveDayWeather: FiveDayWeather) -> [ThreeHourForecast] {
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
