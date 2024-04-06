//
//  GradientItem.swift
//  WeatherDemoApp
//
//  Created by ahmed on 03/04/2024.
//

import UIKit

/// used a base gradient item, to gather required props for creating a gradient layer
struct GradientItem {
    let colors: [CGColor]
    let locations: [NSNumber]
    let startPoint: CGPoint
    let endPoint: CGPoint
}
