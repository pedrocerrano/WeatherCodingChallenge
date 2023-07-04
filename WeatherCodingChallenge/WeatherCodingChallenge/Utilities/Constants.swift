//
//  Constants.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/3/23.
//

import UIKit

enum SFSymbols {
    static let location = "location.circle.fill"
    static let pause    = "pause.circle"
}

enum WeatherSFSymbols {
    static let thunderstorm = "cloud.bolt.rain.fill"
    static let drizzle      = "cloud.drizzle"
    static let rainy        = "cloud.rain"
    static let snowy        = "cloud.snow"
    static let foggy        = "cloud.fog"
    static let sunny        = "sun.max.fill"
    static let cloudy       = "cloud.fill"
}

enum Constraints {
    static let stackHeight: CGFloat         = 45
    static let stackPadding: CGFloat        = 8
    static let conditionsImageSize: CGFloat = 140
}

enum Images {
    static let placeholder = UIImage(systemName: SFSymbols.pause)
}
