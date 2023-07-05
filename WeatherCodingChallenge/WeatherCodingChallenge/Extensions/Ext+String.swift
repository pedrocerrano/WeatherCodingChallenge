//
//  Ext+String.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/5/23.
//

import Foundation

extension String {
    // Simple extension that takes the API date/time string and converts it to look the way I want
    // In this instance, its set up for the 3-hour Forecast
    func convertToTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let sourceDate = formatter.date(from: self)
        
        let convertFormatter = DateFormatter()
        convertFormatter.dateFormat = "h:mm a"
        return convertFormatter.string(from: sourceDate!)
    }
}
