//
//  SearchCityViewModel.swift
//  WeatherDemoApp
//
//  Created by ahmed on 04/04/2024.
//

import Foundation
import Combine

final class SearchCityViewModel: BaseViewModel {
    
    /// output
    let localStorageError = PassthroughSubject<LocalStorageError, Never>()
    let serverError = PassthroughSubject<GenericServerErrorModel, Never>()

    private var cities = [LocalStorageCity]()
    private var disposables = Set<AnyCancellable>()

    /// callbacks
    var reloadTableView: VoidCallback!
    
    /// service(s)
    private let weatherFetcher: WeatherFetchable
    private let localStorageHelper: LocalStorageManagerProtocol
 
    /// injecting dependencies
    init(weatherFetcher: WeatherFetchable,
         localStorageHelper: LocalStorageManagerProtocol) {
        self.weatherFetcher = weatherFetcher
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

extension SearchCityViewModel {
    // MARK: Filter local cities
    
//    func startSearching(_ searchText: String?) {
//        guard let searchText = searchText else {return}
//        
//        /// empt string ? then get all cities
//        if searchText.isEmpty {
//            cities = localStorageHelper.getCities()
//            reloadTableView()
//            return
//        }
//        
//        /// has cities ? then filter with name
//        filterResultsWith(searchText)
//    }
    
    private func filterResultsWith(_ cityName: String) {
        let filteredCities = localStorageHelper.getCities().filter {
            $0.cityName.contains(cityName)
        }
        
        cities = filteredCities
        reloadTableView()
    }
    
    func clickedSearchBtn(_ searchText: String?) {
        guard let searchText = searchText,
              !searchText.isEmpty else {return}
        // api
        fetchWeatherInfo(searchText)
    }
}

extension SearchCityViewModel {
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
}


// MARK: Api calls
extension SearchCityViewModel {
    
    private func fetchWeatherInfo(_ city: String) {
        showIndicator()
        
        weatherFetcher.getWeatherInfo(forCity: city) { [unowned self] result in
            hideIndicator()
            
            switch result {
            case .success(let cityWeatherInfo):
                let city = cityWeatherInfo.getFormattedCityWeatherModel()
                
                do {
                    /// add to DB
                    try self.localStorageHelper.addCity(city)
                    
                    /// update results list
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [unowned self] in
                        filterResultsWith(city.cityName)
                    }
                    
                } catch {
                    if let error = error as? LocalStorageError {
                        self.localStorageError.send(error)
                    }
                }
                
            case.failure(let err):
                self.serverError.send(err)
            }
            
        }
        
    }
}
