//
//  NetworkError.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 22.03.26.
//

import Foundation

enum NetworkError: LocalizedError, Sendable {
    case invalidURL
    case noData
    case decodingError(String)
    case httpError(statusCode: Int)
    case requestCancelled
    case configError(String)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return String(localized: "error.invalidURL")
        case .noData:
            return String(localized: "error.noData")
        case .decodingError(let message):
            return String(localized: "error.decodingError \(message)")
        case .httpError(let statusCode):
            return String(localized: "error.httpError \(statusCode)")
        case .requestCancelled:
            return String(localized: "error.requestCancelled")
        case .configError(let message):
            return String(localized: "error.configError \(message)")
        case .unknown(let error):
            return String(localized: "error.unknown \(error.localizedDescription)")
        }
    }
}
