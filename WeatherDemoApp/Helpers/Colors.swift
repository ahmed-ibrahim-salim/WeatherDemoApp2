//
//  Colors.swift
//  WeatherDemoApp
//
//  Created by ahmed on 03/04/2024.
//

import UIKit

struct Colors {
    
    static private let currentTheme = UITraitCollection.current.userInterfaceStyle
    
    // MARK: Colors

    static var mainBtnBackgroundColor: UIColor? = {
        currentTheme == .light ? UIColor(hex: "2388C7") : UIColor(hex: "C53249")
    }()
    
    static var mainBtnTintColor: UIColor? = {
        currentTheme == .light ? UIColor.white : UIColor(hex: "252526")
    }()
    
    static var labelColor: UIColor? = {
        currentTheme == .light ? UIColor(hex: "3D4548") : UIColor(hex: "797F88")
    }()
    
    static var cancelBtnTint: UIColor? = {
        currentTheme == .light ? UIColor(hex: "007AFF") : UIColor(hex: "C53249")
    }()
    
    static var weatherContainerColor: UIColor? = {
        currentTheme == .light ? UIColor.white : UIColor(hex: "2E2E2E")
    }()
    
    // MARK: Home gradient
    static var pageGradientFirstColor: UIColor? = {
        currentTheme == .light ? UIColor.white : UIColor(hex: "262627")
    }()
    
    static var pageGradientSecondColor: UIColor? = {
        currentTheme == .light ? UIColor(hex: "D6D3DE") : UIColor(hex: "242325")
    }()
    
    static var pageGradient = {
        return GradientItem(
            colors: [
                pageGradientFirstColor?.cgColor,
                pageGradientSecondColor?.cgColor]
                .compactMap {
                    $0
                },
            locations: [0, 1, 1],
            startPoint: CAGradientPoint.topCenter.point,
            endPoint: CAGradientPoint.bottomCenter.point
        )
    }()
}
