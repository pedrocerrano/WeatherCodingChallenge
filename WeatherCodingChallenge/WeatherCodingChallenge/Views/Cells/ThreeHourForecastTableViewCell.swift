//
//  ThreeHourForecastTableViewCell.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/4/23.
//

import SwiftUI

class ThreeHourForecastTableViewCell: UITableViewCell {
    
    //MARK: - Functions
    func set(threeHourForecast: ThreeHourForecast) {
        contentConfiguration = UIHostingConfiguration {
            ThreeHourForecastView(threeHourForecast: threeHourForecast)
        }
    }
}
