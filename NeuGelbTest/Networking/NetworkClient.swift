//
//  NetworkClient.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 22.03.26.
//

import Foundation
import Observation

@Observable
final class NetworkClient: Sendable {
    private let config: NetworkConfig
    private let session: URLSession
    
    init(config: NetworkConfig, session: URLSession = .shared) {
        self.config = config
        self.session = session
    }
    
    func fetch<R: NetworkRequest>(_ request: R) async throws -> R.Response {
        var urlRequest = try request.buildURLRequest()
        urlRequest.setValue("Bearer \(config.accessToken)", forHTTPHeaderField: "Authorization")

        try Task.checkCancellation()
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            // Validate HTTP status code (2xx range)
            if let httpResponse = response as? HTTPURLResponse {
                guard (200..<300).contains(httpResponse.statusCode) else {
                    throw NetworkError.httpError(statusCode: httpResponse.statusCode)
                }
            }
            
            // Check for empty data
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            // Decode JSON response
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(R.Response.self, from: data)
            } catch let decodingError as DecodingError {
                throw NetworkError.decodingError(decodingError.localizedDescription)
            }
        } catch let error as NetworkError {
            throw error
        } catch is CancellationError {
            throw NetworkError.requestCancelled
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    func fetchBinary<R: NetworkRequest>(_ request: R) async throws -> R.Response 
        where R.Response == Data 
    {
        // Build the request
        var urlRequest = try request.buildURLRequest()

        // Auto-add Authorization header
        urlRequest.setValue("Bearer \(config.accessToken)", forHTTPHeaderField: "Authorization")

        // Check for cancellation
        try Task.checkCancellation()
        
        do {
            let (data, response) = try await session.data(for: urlRequest)

            // Validate HTTP status code (2xx range)
            if let httpResponse = response as? HTTPURLResponse {
                guard (200..<300).contains(httpResponse.statusCode) else {
                    throw NetworkError.httpError(statusCode: httpResponse.statusCode)
                }
            }

            // Check for empty data
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            return data 
        } catch let error as NetworkError {
            throw error
        } catch is CancellationError {
            throw NetworkError.requestCancelled
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}
