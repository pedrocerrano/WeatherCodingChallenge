//
//  WeatherViewController.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/3/23.
//

import UIKit
import CoreLocation

class WeatherViewController: DataLoadingViewController {

    //MARK: - Outlets
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var citySearchTextField: UITextField!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentConditionsImageView: UIImageView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var loTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    
    @IBOutlet weak var dailyForecastTableView: UITableView!
    
    
    //MARK: - Properties
    let locationManager = CLLocationManager()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkForAuthorizationConfiguration()
        congifureViewController()
        loadCityForecast()
    }
    
    
    //MARK: - IB Actions
    @IBAction func currentLocationButtonTapped(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    
    //MARK: - Functions
    private func checkForAuthorizationConfiguration() {
        if locationManager.authorizationStatus == .notDetermined {
            Task {
                do {
                    let cityForecast = try await NetworkService.shared.fetchWeatherByCity(forCity: "Plano")
                    self.updateUI(with: cityForecast)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func congifureViewController() {
        view.backgroundColor = .systemCyan
        citySearchTextField.delegate = self
        configureLocationManager()
        createDismissKeyboardTapGesture()
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func loadCityForecast() {
        showLoadingView()
        PersistenceManager.retreiveCityFromDefaults { result in
            switch result {
            case .success(let savedCity):
                Task {
                    do {
                        let cityForecast = try await NetworkService.shared.fetchWeatherByCity(forCity: savedCity.cityName)
                        self.updateUI(with: cityForecast)
                        self.dismissLoadingView()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case .failure(_):
                self.locationManager.requestLocation()
                self.dismissLoadingView()
            }
        }
    }
    
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func updateUI(with cityForecast: CityForecast) {
        cityNameLabel.text               = cityForecast.cityName
        currentConditionsImageView.image = UIImage(systemName: cityForecast.currentConditions)?.withRenderingMode(.alwaysOriginal)
        currentTempLabel.text            = "\(cityForecast.temp.asRoundedString())°F"
        feelsLikeLabel.text              = "Feels like \(cityForecast.feelsLike.asRoundedString())°F"
        loTempLabel.text                 = "L: \(cityForecast.tempLow.asRoundedString())°F"
        highTempLabel.text               = "H: \(cityForecast.tempHigh.asRoundedString())°F"
    }
} //: CLASS


//MARK: - EXT: TextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let cityName = textField.text {
            Task {
                do {
                    let cityForecast = try await NetworkService.shared.fetchWeatherByCity(forCity: cityName)
                    textField.text = ""
                    updateUI(with: cityForecast)
                    let _ = PersistenceManager.saveCityToDefaults(cityForecast: cityForecast)
                } catch {
                    print(error.localizedDescription)
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
                    updateUI(with: cityForecast)
                    let _ = PersistenceManager.saveCityToDefaults(cityForecast: cityForecast)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager did fail with error: \(error)")
    }
}

