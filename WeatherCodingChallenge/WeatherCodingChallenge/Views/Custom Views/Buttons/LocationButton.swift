//
//  LocationButton.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/3/23.
//

import UIKit

class LocationButton: UIButton {

    //MARK: - Designated Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Convenience Initializer
    convenience init(imageColor: UIColor, backgroundColor: UIColor, systemImageName: String) {
        self.init(frame: .zero)
        set(imageColor: imageColor, backgroundColor: backgroundColor, systemImageName: systemImageName)
    }

    
    //MARK: - Functions
    private func configure() {
        configuration              = .filled()
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    final func set(imageColor: UIColor, backgroundColor: UIColor, systemImageName: String) {
        configuration?.baseForegroundColor = imageColor
        configuration?.baseBackgroundColor = backgroundColor
        configuration?.image               = UIImage(systemName: systemImageName)
    }
}
