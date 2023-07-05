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
    private let decoder = JSONDecoder()
    
    // These could easily belong in the Constants file, but I put them here to make the functions below feel less busy and more readable.
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
    
    // I favor async await Concurrency over completion handlers because of how linear they are, but I'm quite comfortable with completion handlers.
    func fetchWeatherByCity(forCity city: String) async throws -> CityForecast {
        guard let baseURL = URL(string: openWeatherURL) else { throw WeatherError.invalidURL }
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path.append(weatherPath)
        
        let appIdQuery    = URLQueryItem(name: appIdKey, value: appIdValue)
        let unitTypeQuery = URLQueryItem(name: unitTypeKey, value: unitTypeValue)
        let cityNameQuery = URLQueryItem(name: cityNameQueryKey, value: city)
        urlComponents?.queryItems = [appIdQuery, unitTypeQuery, cityNameQuery]
        
        guard let finalURL = urlComponents?.url else { throw WeatherError.unableToComplete }
        // I find a printed and clearly labeled URL reference to be of the utmost help in debugging
        // print("SERVICE Search by City finalURL: \(finalURL)")
        
        let (data, response) = try await URLSession.shared.data(from: finalURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        do {
            let forecast = try decoder.decode(Weather.self, from: data)
            return NetworkHelper.createCityForecast(forecast)
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
        // print("SERVICE Search by Location finalURL: \(finalURL)")
        
        let (data, response) = try await URLSession.shared.data(from: finalURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        do {
            let forecast = try decoder.decode(Weather.self, from: data)
            return NetworkHelper.createCityForecast(forecast)
        } catch {
            throw WeatherError.invalidData
        }
    }
    
    func fetchThreeHourForecastsByCity(forCity city: String) async throws -> [ThreeHourForecast] {
        guard let baseURL = URL(string: openWeatherURL) else { throw WeatherError.invalidURL }
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path.append(fiveDayForecastPath)
        
        let appIdQuery    = URLQueryItem(name: appIdKey, value: appIdValue)
        let unitTypeQuery = URLQueryItem(name: unitTypeKey, value: unitTypeValue)
        let cityNameQuery = URLQueryItem(name: cityNameQueryKey, value: city)
        urlComponents?.queryItems = [appIdQuery, unitTypeQuery, cityNameQuery]
        
        guard let finalURL = urlComponents?.url else { throw WeatherError.unableToComplete }
        // print("SERVICE 3-Hour Forecast finalURL: \(finalURL)")
        
        let (data, response) = try await URLSession.shared.data(from: finalURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        do {
            let fiveDayWeather = try decoder.decode(FiveDayWeather.self, from: data)
            return NetworkHelper.createThreeHourForecast(fiveDayWeather)
        } catch {
            throw WeatherError.invalidData
        }
    }
}
