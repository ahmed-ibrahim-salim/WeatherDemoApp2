//
//  SceneDelegate.swift
//  WeatherDemoApp
//
//  Created by ahmed on 01/04/2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            
            /// theme color for device os
            window.overrideUserInterfaceStyle = UIScreen.main.traitCollection.userInterfaceStyle

            let citiesViewModel = CitiesViewModel(localStorageHelper: LocalStorageManager.shared)
            let viewControlller = CitiesViewController(viewModel: citiesViewModel)
            
            let navController = UINavigationController()
            navController.setViewControllers([viewControlller], animated: false)
            
            self.window?.rootViewController = navController
            window.makeKeyAndVisible()
            
        }
    }

}
