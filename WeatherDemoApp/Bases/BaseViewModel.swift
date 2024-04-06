//
//  BaseViewModel.swift
//  WeatherDemoApp
//
//  Created by ahmed on 02/04/2024.
//

import Foundation
import Combine

typealias VoidCallback = (() -> Void)

/// Base View Model to reduce duplication
class BaseViewModel {

    var showIndicator: VoidCallback!
    var hideIndicator: VoidCallback!
    
}
