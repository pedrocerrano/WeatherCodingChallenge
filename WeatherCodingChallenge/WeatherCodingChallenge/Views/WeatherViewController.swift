//
//  WeatherViewController.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/3/23.
//

import UIKit

class WeatherViewController: UIViewController {

    //MARK: - Properties
    let citySearchTextField = CitySearchTextField()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemCyan
        
        createDismissKeyboardTapGesture()
        configureTextField()
    }
    
    //MARK: - Functions
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func configureTextField() {
        view.addSubview(citySearchTextField)
        citySearchTextField.delegate = self
        
        NSLayoutConstraint.activate([
            citySearchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            citySearchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            citySearchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            citySearchTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
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

