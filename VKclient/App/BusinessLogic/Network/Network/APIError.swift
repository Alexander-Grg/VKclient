//
//  APIError.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/15/22.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import Foundation

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
}

enum APIErrors: Int, LocalizedError {
    case badRequest = 400
    case unAuthorized = 401
    case tooManyRequests = 429
    case serverError = 500
    
    var errorDescription: String? {
        switch self {
        case .tooManyRequests:
            return "The total amount of requests has been overflowed"
        case .serverError:
            return "Error on the server side"
        default:
            return "Unknown error"
        }
    }
}

enum APIProviderErrors: LocalizedError {
    case invalidURL
    case dataNil
    case decodingError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .dataNil:
            return "There is no data"
        case .decodingError:
            return "Data has incorrect format"
        default:
            return "Unknown error"
        }
    }
}
