import Foundation
import Models
import SwiftData

@Model
public final class MovieEntity {
    public var tmdbId: Int
    public var title: String
    public var posterPath: String?
    public var voteAverage: Double
    public var overview: String?
    public var releaseDate: String?
    public var pageNumber: Int
    public var order: Int
    public var cachedAtTimestamp: TimeInterval

    public init(from movie: Movie, pageNumber: Int, order: Int = 0) {
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

    public func toMovie() -> Movie {
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
public final class MoviePageMetadata {
    public var pageNumber: Int
    public var totalPages: Int
    public var totalResults: Int
    public var cachedAtTimestamp: TimeInterval = Date().timeIntervalSince1970

    public init(pageNumber: Int, totalPages: Int, totalResults: Int) {
        self.pageNumber = pageNumber
        self.totalPages = totalPages
        self.totalResults = totalResults
        self.cachedAtTimestamp = Date().timeIntervalSince1970
    }

    public func isValid(cacheDuration: TimeInterval) -> Bool {
        let now = Date().timeIntervalSince1970
        let age = now - cachedAtTimestamp
        return age < cacheDuration
    }
}
