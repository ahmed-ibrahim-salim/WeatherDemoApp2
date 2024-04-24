//
//  RequestBuilder.swift
//  WeatherDemoApp
//
//  Created by ahmed on 04/04/2024.
//

import Foundation

extension WeatherFetcher {
    struct OpenWeatherAPI {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5"
        static let key = "4c6eb36cdcfd3de4bddb06d5b9b4b760"
    }
    
    // MARK: City weather info
    func makeWeatherInfoComponents(withCity city: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = OpenWeatherAPI.scheme
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.path + "/weather"
        
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: OpenWeatherAPI.key)
        ]
        
        return components
    }
}
