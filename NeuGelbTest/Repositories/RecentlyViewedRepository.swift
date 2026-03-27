//
//  RecentlyViewedRepository.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 27.03.26.
//

import Foundation

protocol RecentlyViewedRepositoryProtocol {
    func getRecentlyViewed() async throws -> [Movie]
    func saveMovie(_ movie: Movie) async throws
    func clearAll() async throws
}

@MainActor
final class RecentlyViewedRepository: RecentlyViewedRepositoryProtocol {
    @Injected<RecentlyViewedCache> var recentlyViewedCache: RecentlyViewedCache
    
    func getRecentlyViewed() async throws -> [Movie] {
        let recentlyViewedMovies = try recentlyViewedCache.getRecentlyViewed()
        return recentlyViewedMovies.map { $0.toMovie() }
    }
    
    func saveMovie(_ movie: Movie) async throws {
        let recentlyViewedMovie = RecentlyViewedMovie(from: movie)
        try recentlyViewedCache.saveMovie(recentlyViewedMovie)
    }
    
    func clearAll() async throws {
        try recentlyViewedCache.clearAll()
    }
}
