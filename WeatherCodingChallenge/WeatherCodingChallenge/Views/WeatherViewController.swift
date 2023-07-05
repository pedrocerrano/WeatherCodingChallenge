//
//  WeatherViewController.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/3/23.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var citySearchTextField: UITextField!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentConditionsImageView: UIImageView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var loTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    
    @IBOutlet weak var threeHourForecastTableView: UITableView!
    
    
    //MARK: - Properties
    
    // I force-unwrapped this to make make this UIViewController dependent upon the viewModel
    // If it fails, I'll find out quickly
    var viewModel: WeatherViewModel!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = WeatherViewModel(delegate: self)
        congifureViewController()
    }
    
    
    //MARK: - IB Actions
    @IBAction func currentLocationButtonTapped(_ sender: Any) {
        viewModel.locationManager.requestLocation()
    }
    
    
    //MARK: - Functions
    private func congifureViewController() {
        view.backgroundColor = .systemTeal
        viewModel.locationManager.delegate = self
        viewModel.configureLocationManager()
        viewModel.loadDefaultLocation()
        viewModel.loadPersistedCityForecast()
        createDismissKeyboardTapGesture()
        
        citySearchTextField.delegate          = self
        threeHourForecastTableView.dataSource = self
        threeHourForecastTableView.delegate   = self
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func updateUI(with cityForecast: CityForecast) {
        cityNameLabel.text               = cityForecast.cityName
        
        // createCurrentConditions switches over the conditionsID and assigns the name of a custom SFSymbol to the correct weather conditions provided by the API
        // .withRenderingMode(.alwaysOriginal) allows for the SFSymbol to display multiple colors
        currentConditionsImageView.image = UIImage(systemName: cityForecast.conditionsID.createCurrentConditions())?.withRenderingMode(.alwaysOriginal)
        
        // asRoundedString is an extension of Double that formats the value to a whole number
        currentTempLabel.text            = "\(cityForecast.temp.asRoundedString())°F"
        feelsLikeLabel.text              = "Feels like \(cityForecast.feelsLike.asRoundedString())°F"
        loTempLabel.text                 = "L: \(cityForecast.tempLow.asRoundedString())°F"
        highTempLabel.text               = "H: \(cityForecast.tempHigh.asRoundedString())°F"
    }
} //: CLASS


//MARK: - EXT: TextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            viewModel.fetchForecastByCityAndResave(forCity: text)
            textField.text = ""
            textField.resignFirstResponder()
        }
        return true
    }
} //: TextFieldDelegate


//MARK: - LocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            viewModel.locationManager.stopUpdatingLocation()
            let latitude  = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            viewModel.fetchForecastByLocation(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager did fail with error: \(error)")
    }
} //: LocationManagerDelegate


//MARK: - TableViewDataSource and Delegate
extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.threeHourForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dailyForecastCell", for: indexPath) as? ThreeHourForecastTableViewCell else { return UITableViewCell() }
        
        let threeHourForecast = viewModel.threeHourForecast[indexPath.row]
        cell.set(threeHourForecast: threeHourForecast)
        
        return cell
    }
} //: TableViewDataSource and Delegate


//MARK: - ViewModelDelegate
extension WeatherViewController: WeatherViewModelDelegate {
    func updateCityForecast() {
        guard let cityForecast = viewModel.cityForecast else { return }
        DispatchQueue.main.async {
            self.updateUI(with: cityForecast)
            self.threeHourForecastTableView.reloadData()
            // After reloading the tableView, I wanted the data to begin at the top
            self.threeHourForecastTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
} //: ViewModelDelegate
