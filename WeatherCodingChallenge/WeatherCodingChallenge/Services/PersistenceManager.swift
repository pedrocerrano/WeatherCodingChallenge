//
//  PersistenceService.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/4/23.
//

import Foundation

class PersistenceManager {
    
    //MARK: - Properties
    
    // Stores the very small sized data locally
    private let defaults = UserDefaults.standard
    
    private enum Keys { static let savedCity = "savedCity" }
    
    
    //MARK: - Functions
    func saveCityToDefaults(cityForecast: CityForecast) -> WeatherError? {
        defaults.removeObject(forKey: Keys.savedCity)
        do {
            let encoder = JSONEncoder()
            let encodedCity = try encoder.encode(cityForecast)
            defaults.set(encodedCity, forKey: Keys.savedCity)
            return nil
        } catch {
            return .unableToSave
        }
    }
    
    // Utilized a completion handler so that I could deal with the errors after calling the function
    func retreiveCityFromDefaults(completion: @escaping (Result<CityForecast, WeatherError>) -> Void) {
        guard let savedCity = defaults.object(forKey: Keys.savedCity) as? Data else {
            completion(.failure(.invalidData))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let retreivedCity = try decoder.decode(CityForecast.self, from: savedCity)
            completion(.success(retreivedCity))
        } catch {
            completion(.failure(.unableToLoad))
        }
    }
}
