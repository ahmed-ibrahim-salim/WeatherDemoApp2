//
//  CityWeatherModel.swift
//  WeatherDemoApp
//
//  Created by ahmed on 04/04/2024.
//

import Foundation

struct CityWeatherModel: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let sys: Sys
    let name: String
    
    // MARK: Formatted weather data
    /// formatting weather data with a helper method
    func getFormattedCityWeatherModel() -> FormattedCityWeatherModel {
        
        let cityName = name + ", " + sys.country
        let weather: Weather = weather[0]
        let temp = "\(convertTemp(temp: main.temp, from: .kelvin, to: .celsius))"
        let windSpeed = "\(wind.speed) km/h"
        let humidity = "\(main.humidity)%"
        
        return FormattedCityWeatherModel(
            cityName: cityName,
            temp: temp,
            humidity: humidity,
            windSpeed: windSpeed,
            description: weather.main.capitalized,
            icon: weather.icon
        )
        
    }
    
    // MARK: Temp converter
    /// convert temprature
    private func convertTemp(
        temp: Double,
        from inputTempType: UnitTemperature,
        to outputTempType: UnitTemperature
    ) -> String {
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.numberFormatter.maximumFractionDigits = 0
        measurementFormatter.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return measurementFormatter.string(from: output)
      }
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
    let humidity: Int

}

// MARK: - Sys
struct Sys: Codable {
    let country: String
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
}
