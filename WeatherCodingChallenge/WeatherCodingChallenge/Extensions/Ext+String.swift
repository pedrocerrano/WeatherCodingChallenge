//
//  Ext+String.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/5/23.
//

import Foundation

extension String {
    func convertToTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let sourceDate = formatter.date(from: self)
        
        let convertFormatter = DateFormatter()
        convertFormatter.dateFormat = "h:mm a"
        return convertFormatter.string(from: sourceDate!)
    }
}
