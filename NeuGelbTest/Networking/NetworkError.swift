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
            return "Invalid URL provided"
        case .noData:
            return "No data received from the server"
        case .decodingError(let message):
            return "Failed to decode response: \(message)"
        case .httpError(let statusCode):
            return "HTTP Error: \(statusCode)"
        case .requestCancelled:
            return "Request was cancelled"
        case .configError(let message):
            return "Configuration Error: \(message)"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
