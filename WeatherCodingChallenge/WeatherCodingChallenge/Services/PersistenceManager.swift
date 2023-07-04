//
//  PersistenceService.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/4/23.
//

import Foundation

enum PersistenceManager {
    
    //MARK: - Properties
    static private let defaults = UserDefaults.standard
     
    private enum Keys { static let savedCity = "savedCity" }
    
    
    //MARK: - Functions
    static func saveCityToDefaults(cityForecast: CityForecast) -> WeatherError? {
        defaults.removeObject(forKey: Keys.savedCity)
        do {
            let encoder = JSONEncoder()
            let encodedCity = try encoder.encode(cityForecast)
            defaults.set(encodedCity, forKey: Keys.savedCity)
            print("Saved: \(cityForecast.cityName) to Defaults")
            return nil
        } catch {
            return .unableToSave
        }
    }
    
    static func retreiveCityFromDefaults(completion: @escaping (Result<CityForecast, WeatherError>) -> Void) {
        guard let savedCity = defaults.object(forKey: Keys.savedCity) as? Data else {
            completion(.failure(.invalidData))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let retreivedCity = try decoder.decode(CityForecast.self, from: savedCity)
            print("Retreived: \(retreivedCity.cityName) from Defaults")
            completion(.success(retreivedCity))
        } catch {
            completion(.failure(.unableToLoad))
        }
    }
}
