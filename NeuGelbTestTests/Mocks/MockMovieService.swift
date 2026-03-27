//
//  MockMovieService.swift
//  NeuGelbTestTests
//
//  Created by Marco Maddalena on 23.03.26.
//

import Foundation
@testable import NeuGelbTest

final class MockMovieService: MovieServiceProtocol {
    var shouldSucceed: Bool = true
    var mockResponse: MovieListResponse?
    var error: Error?
    
    var fetchMoviesCallCount: Int = 0
    var lastPageRequested: Int?
    
    var detailShouldSucceed: Bool = true
    var detailMockResponse: MovieDetail?
    var detailError: Error?
    
    var fetchMovieDetailCallCount: Int = 0
    var lastMovieIdRequested: Int?
    
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
    
    func simulateDetailSuccess(with response: MovieDetail) {
        detailShouldSucceed = true
        detailMockResponse = response
        detailError = nil
    }
    
    func simulateDetailFailure(with error: Error) {
        detailShouldSucceed = false
        detailMockResponse = nil
        detailError = error
    }
    
    func fetchMovies(page: Int = 1) async throws -> MovieListResponse {
        fetchMoviesCallCount += 1
        lastPageRequested = page
        
        if !shouldSucceed, let error = error {
            throw error
        }
        
        guard let response = mockResponse else {
            throw NetworkError.noData
        }
        
        return response
    }
    
    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        fetchMovieDetailCallCount += 1
        lastMovieIdRequested = id
        
        if !detailShouldSucceed, let error = detailError {
            throw error
        }
        
        guard let response = detailMockResponse else {
            throw NetworkError.noData
        }
        
        return response
    }
}
