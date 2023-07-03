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
    static let shared = NetworkService()
    
    let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    let appIdKey = "appid"
    let appIdValue = "f915325ff07fd674f190487224e5af9e"
    let unitTypeKey = "units"
    let unitTypeValue = "imperial"
    
    
    //MARK: - Functions
    func fetchWeatherByCity(forCity city: String) {
        guard let baseURL = URL(string: baseURL) else { return }
    }
    
    func fetchWeatherbyLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
    }
}
