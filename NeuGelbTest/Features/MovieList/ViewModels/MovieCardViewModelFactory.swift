//
//  MovieCardViewModelFactory.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 25.03.26.
//

import Foundation

@MainActor
final class MovieCardViewModelFactory {
    @Injected<ImageServiceProtocol> var imageService
    
    static func makeMovieCardViewModel(for movie: Movie) -> MovieCardViewModel {
        let factory = MovieCardViewModelFactory()
        return MovieCardViewModel(movie: movie, imageService: factory.imageService)
    }
}
