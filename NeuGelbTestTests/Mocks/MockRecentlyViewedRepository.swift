//
//  MockRecentlyViewedRepository.swift
//  NeuGelbTestTests
//
//  Created by Marco Maddalena on 27.03.26.
//

import Foundation
@testable import NeuGelbTest

final class MockRecentlyViewedRepository: RecentlyViewedRepositoryProtocol {
    var getRecentlyViewedCallCount: Int = 0
    var saveMovieCallCount: Int = 0
    var clearAllCallCount: Int = 0
    
    var mockRecentlyViewed: [Movie] = []
    var shouldThrowOnGet: Bool = false
    var shouldThrowOnSave: Bool = false
    var shouldThrowOnClear: Bool = false
    
    var lastSavedMovie: Movie?
    
    func getRecentlyViewed() async throws -> [Movie] {
        getRecentlyViewedCallCount += 1
        
        if shouldThrowOnGet {
            throw NSError(domain: "MockError", code: 1)
        }
        
        return mockRecentlyViewed
    }
    
    func saveMovie(_ movie: Movie) async throws {
        saveMovieCallCount += 1
        lastSavedMovie = movie
        
        if shouldThrowOnSave {
            throw NSError(domain: "MockError", code: 1)
        }
        
        mockRecentlyViewed.insert(movie, at: 0)
    }
    
    func clearAll() async throws {
        clearAllCallCount += 1
        
        if shouldThrowOnClear {
            throw NSError(domain: "MockError", code: 1)
        }
        
        mockRecentlyViewed = []
    }
    
    func setMockRecentlyViewed(_ movies: [Movie]) {
        mockRecentlyViewed = movies
    }
}
