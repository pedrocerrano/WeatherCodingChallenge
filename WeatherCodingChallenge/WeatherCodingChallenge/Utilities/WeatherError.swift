//
//  WeatherError.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/3/23.
//

import Foundation

enum WeatherError: String, Error {
    case invalidURL       = "Invalid URL. Double check the endpoint."
    case unableToComplete = "Unable to complete the request. Please check the Internet connection."
    case invalidResponse  = "Invalid response from the server. Please try again."
    case invalidData      = "The data received from the server is invalid. Please try again."
    case unableToDecode   = "Unable to decode model object from data."
}
