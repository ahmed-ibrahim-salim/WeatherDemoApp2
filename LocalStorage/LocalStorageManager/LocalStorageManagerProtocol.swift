//
//  LocalStorageManagerProtocol.swift
//  WeatherDemoApp
//
//  Created by ahmed on 06/04/2024.
//

import Foundation
import Combine

protocol LocalStorageManagerProtocol {
    static var shared: LocalStorageManager {get}
    
    func getCities() -> [LocalStorageCity]
    func addCity(_ weatherInfo: FormattedCityWeatherModel) throws
    func deleteCity(by name: String) throws
    func clearDatabase() throws
    
    func changeLocalStorageType(_ localDb: LocalStorageProtocol) -> LocalStorageProtocol
    
    /// outputs
    var cities: PassthroughSubject<Result<[LocalStorageCity], LocalStorageError>, Never> {get}
    
}
