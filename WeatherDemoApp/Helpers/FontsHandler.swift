//
//  FontsHandler.swift
//  WeatherDemoApp
//
//  Created by ahmed on 02/04/2024.
//

import UIKit

enum AppFonts: String {
    
    case bold = "Bold"
    case regular = "Regular"
    case semibold = "Semibold"
    
    // MARK: Private

    private var fullFontName: String {
        let fontName = "SFProText"
        return rawValue.isEmpty ? fontName : (fontName + "-" + rawValue)
    }
    
    func size(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: fullFontName, size: size) {
            return font
        }
        fatalError("Font '\(fullFontName)' does not exist.")
    }
    
}
