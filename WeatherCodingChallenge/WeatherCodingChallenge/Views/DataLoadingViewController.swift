//
//  DataLoadingViewController.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/4/23.
//

import UIKit

class DataLoadingViewController: UIViewController {

    //MARK: - Properties
    var containerView: UIView!
    
    
    //MARK: - Functions
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemCyan
        containerView.alpha           = 0
        
        UIView.animate(withDuration: 0.0) { self.containerView.alpha = 0.8}
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.color = .systemGreen
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
}
