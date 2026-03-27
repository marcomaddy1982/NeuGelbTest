//
//  MockMovieListCache.swift
//  NeuGelbTestTests
//
//  Created by Marco Maddalena on 25.03.26.
//

import Foundation
@testable import NeuGelbTest

final class MockMovieListCache {
    var getMoviesCallCount: Int = 0
    var saveMoviesCallCount: Int = 0
    var clearAllCallCount: Int = 0
    
    var mockResponse: MovieListResponse?
    var shouldThrowOnGet: Bool = false
    var shouldThrowOnSave: Bool = false
    var shouldThrowOnClear: Bool = false
    
    var lastPageRequested: Int?
    var lastCacheDurationRequested: TimeInterval?
    var lastResponseSaved: MovieListResponse?
    var lastPageSaved: Int?
    
    func getMovies(page: Int, cacheDuration: TimeInterval) throws -> MovieListResponse? {
        getMoviesCallCount += 1
        lastPageRequested = page
        lastCacheDurationRequested = cacheDuration
        
        if shouldThrowOnGet {
            throw NetworkError.noData
        }
        
        return mockResponse
    }
    
    func saveMovies(_ response: MovieListResponse, page: Int) throws {
        saveMoviesCallCount += 1
        lastResponseSaved = response
        lastPageSaved = page
        
        if shouldThrowOnSave {
            throw NetworkError.noData
        }
    }
    
    func clearAll() throws {
        clearAllCallCount += 1
        
        if shouldThrowOnClear {
            throw NetworkError.noData
        }
    }
    
    // Helper to set mock response
    func setMockResponse(_ response: MovieListResponse) {
        mockResponse = response
    }
}
