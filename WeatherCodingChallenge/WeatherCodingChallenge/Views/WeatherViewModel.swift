//
//  WeatherViewModel.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/5/23.
//

import Foundation
import CoreLocation

protocol WeatherViewModelDelegate: AnyObject {
    func updateCityForecast()
}

class WeatherViewModel {
    
    //MARK: - Properties
    var cityForecast: CityForecast?
    var threeHourForecast: [ThreeHourForecast] = []
    
    let locationManager = CLLocationManager()
    let service: NetworkService
    let persistence: PersistenceManager
    private weak var delegate: WeatherViewModelDelegate?
    
    
    //MARK: - Dependency Injection
    init(service: NetworkService = NetworkService(), persistence: PersistenceManager = PersistenceManager(), delegate: WeatherViewModelDelegate) {
        self.service     = service
        self.persistence = persistence
        self.delegate    = delegate
    }
    
    
    //MARK: - Functions
    func configureLocationManager() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func loadDefaultLocation() {
        if locationManager.authorizationStatus == .notDetermined {
            let appLaunchCityName = "Plano"
            fetchForecastByCityAndResave(forCity: appLaunchCityName)
        } else {
            return
        }
    }
    
    func fetchForecastByCityAndResave(forCity city: String) {
        Task {
            do {
                let fetchedCityForecast  = try await service.fetchWeatherByCity(forCity: city)
                let fetchedThreeHourForecast = try await service.fetchFiveDayForecastByCity(forCity: city)
                self.cityForecast = fetchedCityForecast
                self.threeHourForecast = fetchedThreeHourForecast
                
                self.delegate?.updateCityForecast()
                let _ = persistence.saveCityToDefaults(cityForecast: fetchedCityForecast)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchForecastByLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        Task {
            do {
                let newCityForecast = try await service.fetchWeatherbyLocation(latitude: latitude, longitude: longitude)
                let newThreeHourForecast = try await service.fetchFiveDayForecastByCity(forCity: newCityForecast.cityName)
                self.cityForecast = newCityForecast
                self.threeHourForecast = newThreeHourForecast
                
                self.delegate?.updateCityForecast()
                let _ = persistence.saveCityToDefaults(cityForecast: newCityForecast)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadPersistedCityForecast() {
        persistence.retreiveCityFromDefaults { result in
            switch result {
            case .success(let savedCity):
                self.fetchForecastByCityAndResave(forCity: savedCity.cityName)
            case .failure(_):
                self.locationManager.requestLocation()
            }
        }
    }
}
