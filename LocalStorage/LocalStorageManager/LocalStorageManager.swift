//
//  LocalStorageManager.swift
//  WeatherDemoApp
//
//  Created by ahmed on 06/04/2024.
//

import Foundation
import Combine

class LocalStorageManager: LocalStorageManagerProtocol {
    
    static let shared = LocalStorageManager(helper: RealmStorageHelper()) /// Realm as default local storage
    /// outputs
    let cities = PassthroughSubject<Result<[LocalStorageCity], LocalStorageError>, Never>()

    private var localStorageHelper: LocalStorageProtocol
    private var disposables = Set<AnyCancellable>()

    private init(helper: LocalStorageProtocol) {
        self.localStorageHelper = helper
        observeOnCities()
    }
    
    private func observeOnCities() {
        localStorageHelper.cities.sink { [unowned self] result in
            cities.send(result)
        }.store(in: &disposables)
    }
    
    /// reinject a different database helper
    func changeLocalStorageType(_ localDb: LocalStorageProtocol) -> LocalStorageProtocol {
        localStorageHelper = localDb
        return localStorageHelper
    }
    
    func getCities() -> [LocalStorageCity] {
       localStorageHelper.getCitiesData()
    }

    func addCity(_ weatherInfo: FormattedCityWeatherModel) throws {
        try localStorageHelper.addCityWeatherInfoToLocalStorage(weatherInfo: weatherInfo)
    }

    func deleteCity(by name: String) throws {
      try localStorageHelper.deleteCityFromLocalStorage(name)
    }
    
    func clearDatabase() throws {
        try localStorageHelper.clearDatabase()
    }

}
