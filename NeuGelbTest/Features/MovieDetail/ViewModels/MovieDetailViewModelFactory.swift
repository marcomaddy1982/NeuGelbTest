//
//  MovieDetailViewModelFactory.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 25.03.26.
//

import Foundation

@MainActor
final class MovieDetailViewModelFactory {
    @Injected<MovieServiceProtocol> var movieService
    @Injected<ImageServiceProtocol> var imageService
    
    static func makeMovieDetailViewModel(for movie: Movie) -> MovieDetailViewModel {
        let factory = MovieDetailViewModelFactory()
        return MovieDetailViewModel(
            movie: movie,
            movieService: factory.movieService,
            imageService: factory.imageService
        )
    }
}
