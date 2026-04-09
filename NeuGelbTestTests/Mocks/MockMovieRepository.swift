//
//  MockMovieRepository.swift
//  NeuGelbTestTests
//
//  Created by Marco Maddalena on 25.03.26.
//

import Foundation
@testable import NeuGelbTest

final class MockMovieRepository: MovieRepositoryProtocol {
    var getMoviesCallCount: Int = 0
    var clearCacheCallCount: Int = 0
    
    var mockResponse: MovieListResponse?
    var shouldThrowOnGet: Bool = false
    var shouldThrowOnClear: Bool = false
    
    var lastPageRequested: Int?
    var lastForceRefreshRequested: Bool?
    
    func getMovies(page: Int, forceRefresh: Bool = false) async throws -> MovieListResponse {
        getMoviesCallCount += 1
        lastPageRequested = page
        lastForceRefreshRequested = forceRefresh
        
        if shouldThrowOnGet {
            throw NetworkError.noData
        }
        
        guard let response = mockResponse else {
            throw NetworkError.noData
        }
        
        return response
    }
    
    func clearCache() async throws {
        clearCacheCallCount += 1
        
        if shouldThrowOnClear {
            throw NetworkError.noData
        }
    }
    
    // Helper to set mock response
    func setMockResponse(_ response: MovieListResponse) {
        mockResponse = response
    }
}
