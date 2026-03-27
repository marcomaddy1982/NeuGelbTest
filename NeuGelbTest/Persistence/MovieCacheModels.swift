import SwiftData
import Foundation

@Model
final class MovieEntity {
    var tmdbId: Int
    var title: String
    var posterPath: String?
    var voteAverage: Double
    var overview: String?
    var releaseDate: String?
    var pageNumber: Int
    var order: Int
    var cachedAtTimestamp: TimeInterval
    
    init(from movie: Movie, pageNumber: Int, order: Int = 0) {
        self.tmdbId = movie.tmdbId
        self.title = movie.title
        self.posterPath = movie.posterPath
        self.voteAverage = movie.voteAverage
        self.overview = movie.overview
        self.releaseDate = movie.releaseDate
        self.pageNumber = pageNumber
        self.order = order
        self.cachedAtTimestamp = Date().timeIntervalSince1970
    }
    
    func toMovie() -> Movie {
        Movie(
            tmdbId: tmdbId,
            title: title,
            posterPath: posterPath,
            voteAverage: voteAverage,
            overview: overview,
            releaseDate: releaseDate
        )
    }
}

@Model
final class MoviePageMetadata {
    var pageNumber: Int
    var totalPages: Int
    var totalResults: Int
    var cachedAtTimestamp: TimeInterval = Date().timeIntervalSince1970

    init(pageNumber: Int, totalPages: Int, totalResults: Int) {
        self.pageNumber = pageNumber
        self.totalPages = totalPages
        self.totalResults = totalResults
        self.cachedAtTimestamp = Date().timeIntervalSince1970
    }

    func isValid(cacheDuration: TimeInterval) -> Bool {
        let now = Date().timeIntervalSince1970
        let age = now - cachedAtTimestamp
        return age < cacheDuration
    }
}
