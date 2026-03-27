//
//  MockSearchService.swift
//  NeuGelbTestTests
//
//  Created by Marco Maddalena on 25.03.26.
//

import Foundation
@testable import NeuGelbTest

final class MockSearchService: SearchServiceProtocol {
    var shouldSucceed: Bool = true
    var mockResponse: MovieListResponse?
    var error: Error?
    
    var searchMoviesCallCount: Int = 0
    var lastQueryRequested: String?
    var lastPageRequested: Int?
    
    init() {}
    
    func simulateSuccess(with response: MovieListResponse) {
        shouldSucceed = true
        mockResponse = response
        error = nil
    }
    
    func simulateFailure(with error: Error) {
        shouldSucceed = false
        mockResponse = nil
        self.error = error
    }
    
    func searchMovies(query: String, page: Int) async throws -> MovieListResponse {
        searchMoviesCallCount += 1
        lastQueryRequested = query
        lastPageRequested = page
        
        if !shouldSucceed, let error = error {
            throw error
        }
        
        guard let response = mockResponse else {
            throw NetworkError.noData
        }
        
        return response
    }
}
