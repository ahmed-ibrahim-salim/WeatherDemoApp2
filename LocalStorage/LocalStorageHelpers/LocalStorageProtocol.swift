//
//  LocalStorageHelperProtocol.swift
//  WeatherDemoApp
//
//  Created by ahmed on 06/04/2024.
//

import Foundation
import Combine

protocol LocalStorageProtocol {
    
    /// outputs
    var cities: PassthroughSubject<Result<[LocalStorageCity], LocalStorageError>, Never> {get}
    
    func getCitiesData() -> [LocalStorageCity]
    
    /// inputs
    func addCityWeatherInfoToLocalStorage(weatherInfo: FormattedCityWeatherModel) throws
    func deleteCityFromLocalStorage(_ cityName: String) throws
    func clearDatabase() throws
    
    init()
}
