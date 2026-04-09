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
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200..<300).contains(httpResponse.statusCode) else {
                    throw NetworkError.httpError(statusCode: httpResponse.statusCode)
                }
            }
            
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            if R.Response.self == Data.self {
                return data as! R.Response
            }
            
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
}
