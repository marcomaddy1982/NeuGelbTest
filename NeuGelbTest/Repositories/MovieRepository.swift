import Foundation

protocol MovieRepositoryProtocol {
    func getMovies(page: Int, forceRefresh: Bool) async throws -> MovieListResponse
    func clearCache() async throws
}

@MainActor
final class MovieRepository: MovieRepositoryProtocol {
    @Injected<MovieServiceProtocol> var movieService: MovieServiceProtocol
    @Injected<MovieListCache> var movieListCache: MovieListCache
    
    func getMovies(page: Int, forceRefresh: Bool = false) async throws -> MovieListResponse {
        if !forceRefresh {
            let cachedResponse = try movieListCache.getMovies(page: page, cacheDuration: CacheConstants.movieListCacheDuration)
            if let cachedResponse = cachedResponse {
                return cachedResponse
            }
        }

        let apiResponse = try await movieService.fetchMovies(page: page)
        try movieListCache.saveMovies(apiResponse, page: page)
        return apiResponse
    }
    
    func clearCache() async throws {
        try movieListCache.clearAll()
    }
}

