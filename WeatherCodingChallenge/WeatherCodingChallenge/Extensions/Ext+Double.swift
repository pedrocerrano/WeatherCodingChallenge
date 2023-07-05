//
//  Ext+Double.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/4/23.
//

import Foundation

extension Double {
    // Used to round the temperature values to whole numbers
    func asRoundedString() -> String {
        return String(format: "%.0f", self)
    }
}
