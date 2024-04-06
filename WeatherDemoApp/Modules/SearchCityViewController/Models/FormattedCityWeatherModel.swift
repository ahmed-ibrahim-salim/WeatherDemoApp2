//
//  CityWeatherInternal.swift
//  WeatherDemoApp
//
//  Created by ahmed on 04/04/2024.
//

import Foundation
import RealmSwift

final class FormattedCityWeatherModel: Object {
    @Persisted var cityName: String
    @Persisted var temp: String
    @Persisted var humidity: String
    @Persisted var windSpeed: String
    @Persisted var desc: String
    @Persisted var icon: String
    @Persisted private var dateTime = Date()
    
    convenience init(
        cityName: String,
        temp: String,
        humidity: String,
        windSpeed: String,
        description: String,
        icon: String
    ) {
        self.init()
        
        self.cityName = cityName
        self.temp = temp
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.desc = description
        self.icon = icon
    }
    
    /// null object pattern, to reduce null checks everywhere in the codebase
    static func makeDefaultObject() -> FormattedCityWeatherModel {
        FormattedCityWeatherModel(
            cityName: "",
            temp: "",
            humidity: "",
            windSpeed: "",
            description: "",
            icon: ""
        )
    }
    
    func getDateTimeFormatted() -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let formattedDate = formatter.string(from: dateTime)
        
        formatter.dateFormat = "HH:mm a"
        let formattedTime = formatter.string(from: dateTime)
        
        return "\(formattedDate) - \(formattedTime)"

    }
    
    func getWeatherDescAndTemp() -> String {
        "\(desc), \(temp)"
    }
}
