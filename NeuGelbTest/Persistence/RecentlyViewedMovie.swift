//
//  RecentlyViewedMovie.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 27.03.26.
//

import SwiftData
import Foundation

@Model
final class RecentlyViewedMovie {
    @Attribute(.unique) var tmdbId: Int
    var title: String
    var posterPath: String?
    var voteAverage: Double
    var overview: String?
    var releaseDate: String?
    var viewedAtTimestamp: TimeInterval
    
    init(from movie: Movie) {
        self.tmdbId = movie.tmdbId
        self.title = movie.title
        self.posterPath = movie.posterPath
        self.voteAverage = movie.voteAverage
        self.overview = movie.overview
        self.releaseDate = movie.releaseDate
        self.viewedAtTimestamp = Date().timeIntervalSince1970
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
