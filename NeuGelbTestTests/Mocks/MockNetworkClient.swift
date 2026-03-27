//
//  MockNetworkClient.swift
//  NeuGelbTestTests
//
//  Created by Marco Maddalena on 22.03.26.
//

import Foundation
@testable import NeuGelbTest

final class MockNetworkClient: Sendable {
    nonisolated(unsafe) var shouldSucceed: Bool = true
    nonisolated(unsafe) var mockResponse: Data?
    nonisolated(unsafe) var error: NetworkError?
    
    init() {}

    func simulateSuccess(with data: Data) {
        shouldSucceed = true
        mockResponse = data
        error = nil
    }

    func simulateFailure(with error: NetworkError) {
        shouldSucceed = false
        mockResponse = nil
        self.error = error
    }
    
    func fetch<R: NetworkRequest>(_ request: R) async throws -> R.Response {
        if !shouldSucceed, let error = error {
            throw error
        }
        
        guard let data = mockResponse else {
            throw NetworkError.noData
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(R.Response.self, from: data)
    }
}
