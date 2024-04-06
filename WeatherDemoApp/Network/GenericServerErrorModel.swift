//
//  WeatherError.swift
//  WeatherDemoApp
//
//  Created by ahmed on 04/04/2024.
//

import Foundation
import Alamofire

// MARK: GenericServerErrorModel
/// generic server error model
struct GenericServerErrorModel: LocalizedError, Codable {
    var cod, message: String?
    
    var weatherError: WeatherError?
    
    init(weatherError: WeatherError) {
        self.weatherError = weatherError
        self.message = weatherError.localizedDescription
    }
    
    // MARK: WeatherError
    enum WeatherError: Error, Codable {
        case parsing(description: String)
        case noInternetConnection(description: String)
        case network(description: String)
        case server(description: String)
        case custom(description: String)

        var localizedDescription: String {
            switch self {
            case .network(let value):
                return value
            case .server(let value):
                return value
            case .noInternetConnection(let value):
                return value
            case .parsing(let value):
                return value
            case .custom(let value):
                return value
            }
        }
    }

}

// MARK: decode Server Error
extension GenericServerErrorModel {
    
    static func decodeServerError(data: Data) throws -> GenericServerErrorModel {
        
        do {
            
            let responseError = try JSONDecoder.decodeFromData(GenericServerErrorModel.self, data: data)
//            let newError = GenericServerErrorModel(weatherError: .server(description: responseError.message ?? ""))
            return responseError
            
        } catch {

            throw error
        }
    }
}
