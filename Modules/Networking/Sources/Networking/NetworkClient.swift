//
//  NetworkClient.swift
//  Networking
//

import Foundation
import Observation

@Observable
public final class NetworkClient: Sendable {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func fetch<R: NetworkRequest>(_ request: R) async throws -> R.Response {
        let urlRequest = try request.buildURLRequest()

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
