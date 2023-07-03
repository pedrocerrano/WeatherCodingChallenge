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
    convenience init(fontColor: UIColor, backgroundColor: UIColor, title: String) {
        self.init(frame: .zero)
        set(fontColor: fontColor, backgroundColor: backgroundColor, title: title)
    }

    
    //MARK: - Functions
    private func configure() {
        configuration              = .filled()
        configuration?.cornerStyle = .medium
        configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { font in
            var title = font
            title.font = UIFont.preferredFont(forTextStyle: .title3)
            return title
        }
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    final func set(fontColor: UIColor, backgroundColor: UIColor, title: String) {
        configuration?.baseForegroundColor = fontColor
        configuration?.baseBackgroundColor = backgroundColor
        configuration?.title               = title
    }
}
