//
//  UIView.swift
//  WeatherDemoApp
//
//  Created by ahmed on 03/04/2024.
//

import UIKit

extension UIView {
    /// reusable function to change view controller background gradient layer color.
    func setGradient(colors: [CGColor],
                     locations: [NSNumber],
                     startPoint: CGPoint,
                     endPoint: CGPoint) -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = colors
        gradientLayer.frame = bounds
        
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        return gradientLayer
    }
}
