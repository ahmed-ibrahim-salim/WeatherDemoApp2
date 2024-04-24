//
//  Decoder.swift
//  WeatherDemoApp
//
//  Created by ahmed on 04/04/2024.
//

import Foundation

extension JSONDecoder {
    static func decodeFromData<U: Codable>(_ model: U.Type, data: Data) throws -> U {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            return try decoder.decode(U.self, from: data)
        } catch let error {
            print(model,"model with serialization error :)")
            debugPrint(error)
            throw error
        }
    }
}
