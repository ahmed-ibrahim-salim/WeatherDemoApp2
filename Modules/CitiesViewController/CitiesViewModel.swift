//
//  CitiesViewModel.swift
//  WeatherDemoApp
//
//  Created by ahmed on 04/04/2024.
//

import Foundation
import Combine

final class CitiesViewModel: BaseViewModel {
    
    /// outputs
    let localStorageError = PassthroughSubject<LocalStorageError, Never>()
    let serverError = PassthroughSubject<GenericServerErrorModel, Never>()
    
    private var cities = [LocalStorageCity]()
    private var disposables = Set<AnyCancellable>()

    /// callbacks
    var reloadTableView: VoidCallback!
    
    /// service(s)
    private let localStorageHelper: LocalStorageManagerProtocol

    /// injecting dependencies
    init(localStorageHelper: LocalStorageManagerProtocol) {
        self.localStorageHelper = localStorageHelper
        super.init()
                
        self.startObservingCities()

    }
    
    // MARK: Observing
    private func startObservingCities() {
        localStorageHelper.cities.sink { [unowned self] result in
            
            switch result {
            case .success(let cities):
                self.cities = cities
                reloadTableView()

            case .failure(let error):
                localStorageError.send(error)
            }
            
        }.store(in: &disposables)
    }
}

extension CitiesViewModel {
    // MARK: Table Datasource
    func getCityNameFor(_ index: Int) -> String {
        getCityFor(index).cityName
    }
    
    func getCitiesCount() -> Int {
        cities.count
    }
    
    func getCityFor(_ index: Int) -> LocalStorageCity {
        cities[index]
    }
    
    func deleteCity(_ index: Int) {
        let cityName = getCityNameFor(index)
        do {
            try localStorageHelper.deleteCity(by: cityName)
        } catch {
            if let error = error as? LocalStorageError {
                self.localStorageError.send(error)
            }
        }
    }
}
