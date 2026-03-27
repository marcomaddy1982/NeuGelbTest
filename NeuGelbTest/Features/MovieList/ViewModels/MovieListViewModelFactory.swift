//
//  MovieListViewModelFactory.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 25.03.26.
//

import Foundation

@MainActor
final class MovieListViewModelFactory {
    @Injected<MovieServiceProtocol> var movieService
    @Injected<ImageServiceProtocol> var imageService
    
    static func makeMovieListViewModel() -> MovieListViewModel {
        let factory = MovieListViewModelFactory()
        return MovieListViewModel(
            movieService: factory.movieService,
            imageService: factory.imageService
        )
    }
}
