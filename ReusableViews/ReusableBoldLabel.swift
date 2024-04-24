//
//  ReusableLabel.swift
//  WeatherDemoApp
//
//  Created by ahmed on 03/04/2024.
//

import UIKit

final class ReusableBoldLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: Setup Views
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        font = AppFonts.bold.size(20)
        textColor = Colors.labelColor
        numberOfLines = 0
        textAlignment = .center
    }
    
    // MARK: Setters
    func setAlignment(_ alignment: NSTextAlignment) {
        textAlignment = alignment
    }
    
    func setTitle(_ title: String) {
        text = title
    }
    
    func changeFont(_ font: UIFont) {
        self.font = font
    }
    
    func changeTextColor(_ color: UIColor) {
        self.textColor = color
    }
}
