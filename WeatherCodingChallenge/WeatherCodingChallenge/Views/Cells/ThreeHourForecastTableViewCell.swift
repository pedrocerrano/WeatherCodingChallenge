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
        // This is a SwiftUI view in place of outlets, storyboards and constraints
        // Much simpler and easier to use
        contentConfiguration = UIHostingConfiguration {
            ThreeHourForecastView(threeHourForecast: threeHourForecast)
        }
    }
}
