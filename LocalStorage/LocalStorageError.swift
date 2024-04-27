//
//  RealmDBError.swift
//  WeatherDemoApp
//
//  Created by ahmed on 06/04/2024.
//

import Foundation

enum LocalStorageError: LocalizedError {
    case addError
    case deleteError
    case observationError
    
    var localizedDescription: String {
        switch self {
        case .addError:
            return "Error happend while adding entity to local storage"
        case .observationError:
            return "Something went wrong"
        case .deleteError:
            return "Error happend while deleting entity to local storage"
        }
    }
}
