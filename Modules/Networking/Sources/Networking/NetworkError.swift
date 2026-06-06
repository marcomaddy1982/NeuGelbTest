//
//  NetworkError.swift
//  Networking
//

import Foundation

public enum NetworkError: LocalizedError, Sendable {
    case invalidURL
    case noData
    case decodingError(String)
    case httpError(statusCode: Int)
    case requestCancelled
    case configError(String)
    case unknown(Error)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .requestCancelled:
            return "Request was cancelled"
        case .configError(let message):
            return "Configuration error: \(message)"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
