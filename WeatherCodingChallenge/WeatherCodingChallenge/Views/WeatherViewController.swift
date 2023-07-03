//
//  WeatherViewController.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/3/23.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    //MARK: - Properties
    let locationButton      = LocationButton(imageColor: .white, backgroundColor: .systemBlue, systemImageName: SFSymbols.location)
    let citySearchTextField = CitySearchTextField()
    
    let locationManager = CLLocationManager()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemCyan
        
        configureLocationManager()
        createDismissKeyboardTapGesture()
        configureLocationButton()
        configureTextField()
    }
    
    //MARK: - Functions
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func configureLocationButton() {
        view.addSubview(locationButton)
        locationButton.addTarget(self, action: #selector(requestCurrentLocation), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            locationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constraints.stackPadding),
            locationButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constraints.stackPadding),
            locationButton.heightAnchor.constraint(equalToConstant: Constraints.stackHeight),
            locationButton.widthAnchor.constraint(equalTo: locationButton.heightAnchor)
        ])
    }
    
    @objc func requestCurrentLocation() {
        locationManager.requestLocation()
    }
    
    private func configureTextField() {
        view.addSubview(citySearchTextField)
        citySearchTextField.delegate = self
        
        NSLayoutConstraint.activate([
            citySearchTextField.topAnchor.constraint(equalTo: locationButton.topAnchor),
            citySearchTextField.leadingAnchor.constraint(equalTo: locationButton.trailingAnchor, constant: Constraints.stackPadding),
            citySearchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constraints.stackPadding),
            citySearchTextField.heightAnchor.constraint(equalToConstant: Constraints.stackHeight)
        ])
    }
    
    private func updateUI(withForecast cityforecast: CityForecast) {
        #warning("Create outlets")
    }
} //: CLASS


//MARK: - EXT: TextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let cityName = textField.text {
            Task {
                do {
                    print("\(cityName)")
                    let cityForecast = try await NetworkService.shared.fetchWeatherByCity(forCity: cityName)
                    textField.text = ""
                    print("The current temp in \(cityForecast.cityName) is \(cityForecast.temp)")
                } catch {
                    if let weatherError = error as? WeatherError {
                        #warning("Add custom alert")
                    } else {
                        #warning("Add default Error")
                    }
                }
            }
        }
        return true
    }
} //: TextFieldDelegate


//MARK: - LocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude  = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            Task {
                do {
                    let cityForecast = try await NetworkService.shared.fetchWeatherbyLocation(latitude: latitude, longitude: longitude)
                    print("Current city is: \(cityForecast.cityName), and the current temp is \(cityForecast.temp)")
                } catch {
                    if let weatherError = error as? WeatherError {
                        #warning("Add custom alert")
                    } else {
                        #warning("Add default Error")
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager did fail with error: \(error)")
    }
}

