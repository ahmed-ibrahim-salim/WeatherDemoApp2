//
//  WeatherFetcher.swift
//  WeatherDemoApp
//
//  Created by ahmed on 04/04/2024.
//

import Foundation
import Alamofire
import Reachability

typealias NetworkCompletion<T> = (Result<T, GenericServerErrorModel>) -> Void

protocol WeatherFetchable {
    func getWeatherInfo(forCity city: String,
                        completionHandler: @escaping (Result<CityWeatherModel, GenericServerErrorModel>) -> Void)
    
}

// MARK: - WeatherFetcher
/// final class responsible for requesting data from the server
final class WeatherFetcher: WeatherFetchable {
    
    /// check network status
    let reachability = try? Reachability()
    
    /// get weather info for a city
    func getWeatherInfo(forCity city: String,
                        completionHandler: @escaping (Result<CityWeatherModel, GenericServerErrorModel>) -> Void) {
        
        execute(with: makeWeatherInfoComponents(withCity: city),
                CityWeatherModel.self) { response in
            completionHandler(response)
        }
    }
    
    // MARK: - Execute requests
    /// generic request to execute all get requests
    private func execute<T: Codable>(
        with components: URLComponents,
        _ type: T.Type,
        completionHandler: @escaping NetworkCompletion<T>) {
            
            // return with url error
            guard let url = components.url else {
                let genericError = GenericServerErrorModel(weatherError: .custom(description: "Couldn't create URL"))
                completionHandler(.failure(genericError))
                return
            }
            
            AF.request(url)
                .responseDecodable(of: type) { response in
        
                    self.processResponse(response: response, decodedTo: type) { result in
                        
                        completionHandler(result)
                    }
                }
        }
}

// MARK: - Process response
extension WeatherFetcher {
    /// process all kind of responses from the server including network connectivity, decoding and server errors.
    func processResponse<T: Codable>(response: DataResponse<T, AFError>,
                                     decodedTo type: T.Type,
                                     completion: @escaping NetworkCompletion<T>) {
        
        // MARK: Reachability
        
        /// Check for internet connectivity
        if let reachability = self.reachability,
           reachability.connection != .unavailable {
            /// You have a valid network connection
        } else {
            /// No network connection
            let networkGeneric = GenericServerErrorModel(weatherError: .noInternetConnection(description: "No internet connection"))
            
            completion(.failure(networkGeneric))
            
            return
        }
        
        // MARK: Success
        switch response.result {
        case .success:
            guard let data = response.data else {
                /// request is succes & server returned not data.
                let networkGeneric = GenericServerErrorModel(weatherError: .server(description: "Server returned no data"))
                completion(.failure(networkGeneric))
                
                return
            }
            
            do {
                /// decoding request data.
                let data = try JSONDecoder.decodeFromData(type, data: data)
                completion(.success(data))
                
            } catch {
                print(type, String(describing: error))
                
                /// handling decoding errors
                let networkGeneric = GenericServerErrorModel(weatherError: .parsing(description: error.localizedDescription))
                completion(.failure(networkGeneric))
            }
            
            // MARK: Failure
        case .failure:
            
            do {
                /// decoding request error (backend generic error respose).
                let error = try GenericServerErrorModel.decodeServerError(data: response.data ?? Data())
                
                completion(.failure(error))
                
            } catch {
                /// handling backend error decoding
                let networkGeneric = GenericServerErrorModel(weatherError: .parsing(description: error.localizedDescription))
                completion(.failure(networkGeneric))
            }
        }
    }
}
