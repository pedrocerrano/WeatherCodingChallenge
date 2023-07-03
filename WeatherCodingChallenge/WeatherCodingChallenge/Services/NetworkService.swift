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
    static let shared   = NetworkService()
    private let decoder = JSONDecoder()
    
    private let openWeatherURL = "https://api.openweathermap.org/data/2.5/weather"
    private let appIdKey       = "appid"
    private let appIdValue     = "f915325ff07fd674f190487224e5af9e"
    private let unitTypeKey    = "units"
    private let unitTypeValue  = "imperial"
    
    private let cityNameQueryKey  = "q"
    private let latitudeQueryKey  = "lat"
    private let longitudeQueryKey = "lon"
    
    
    //MARK: - Functions
    func fetchWeatherByCity(forCity city: String) async throws -> CityForecast {
        guard let baseURL = URL(string: openWeatherURL) else { throw WeatherError.invalidURL }
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let appIdQuery    = URLQueryItem(name: appIdKey, value: appIdValue)
        let unitTypeQuery = URLQueryItem(name: unitTypeKey, value: unitTypeValue)
        let cityNameQuery = URLQueryItem(name: cityNameQueryKey, value: city)
        urlComponents?.queryItems = [appIdQuery, unitTypeQuery, cityNameQuery]
        
        guard let finalURL = urlComponents?.url else { throw WeatherError.invalidURL }
        print("City Search finalURL: \(finalURL)")
        
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
        
        let appIdQuery     = URLQueryItem(name: appIdKey, value: appIdValue)
        let unitTypeQuery  = URLQueryItem(name: unitTypeKey, value: unitTypeValue)
        let latitudeQuery  = URLQueryItem(name: latitudeQueryKey, value: String("\(latitude)"))
        let longitudeQuery = URLQueryItem(name: longitudeQueryKey, value: String("\(longitude)"))
        urlComponents?.queryItems = [appIdQuery, unitTypeQuery, latitudeQuery, longitudeQuery]
        
        guard let finalURL = urlComponents?.url else { throw WeatherError.invalidURL }
        print("Location Search finalURL: \(finalURL)")
        
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
    
    private func createCityForecast(_ forecast: Weather) -> CityForecast {
        return CityForecast(cityName: forecast.cityName,
                            temp: forecast.details.temp,
                            feelsLike: forecast.details.feelsLike,
                            tempLow: forecast.details.low,
                            tempHigh: forecast.details.high,
                            conditionsDescription: forecast.current[0].description,
                            conditionsID: forecast.current[0].id)
    }
}
