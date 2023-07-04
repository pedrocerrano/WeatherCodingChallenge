//
//  Ext+Double.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/4/23.
//

import Foundation

extension Double {
    func asRoundedString() -> String {
        return String(format: "%.0f", self)
    }
}
