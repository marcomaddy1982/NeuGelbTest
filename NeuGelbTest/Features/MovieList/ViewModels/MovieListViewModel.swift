//
//  MovieListViewModel.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 23.03.26.
//

import Foundation
import os
import Combine

enum ViewState: Equatable {
    case loading
    case success([Movie])
    case error(String)
}

@MainActor
final class MovieListViewModel: ObservableObject {
    @Published var state: ViewState = .loading
    @Published var isPaginationLoading: Bool = false
    @Published var currentPage: Int = 1
    @Published var hasMorePages: Bool = true
    
    private let movieService: MovieServiceProtocol
    private let imageService: ImageServiceProtocol
    
    init(movieService: MovieServiceProtocol, imageService: ImageServiceProtocol) {
        self.movieService = movieService
        self.imageService = imageService
    }
    
    func loadMovies() async {
        state = .loading
        
        do {
            let response = try await movieService.fetchMovies(page: 1)
            self.state = .success(response.results)
            self.currentPage = response.page
            self.hasMorePages = response.page < response.totalPages
            print("🎬 Loaded page 1: \(response.results.count) movies")
        } catch {
            let errorMessage = "Failed to load movies: \(error.localizedDescription)"
            self.state = .error(errorMessage)
            print("❌ Failed to load movies: \(error.localizedDescription)")
        }
    }
    
    func loadNextPage() async {
        guard hasMorePages && !isPaginationLoading else { return }
        guard case .success(var movies) = state else { return }
        
        isPaginationLoading = true
        let nextPage = currentPage + 1
        
        do {
            let response = try await movieService.fetchMovies(page: nextPage)
            movies.append(contentsOf: response.results)
            self.state = .success(movies)
            self.currentPage = response.page
            self.hasMorePages = response.page < response.totalPages
            print("🎬 Loaded page \(nextPage): \(response.results.count) more movies")
        } catch {
            print("❌ Failed to load page \(nextPage): \(error.localizedDescription)")
        }
        
        isPaginationLoading = false
    }
    
    func shouldLoadNextPage(for movie: Movie) -> Bool {
        guard case .success(let movies) = state,
              let lastMovie = movies.last else { return false }
        return movie.id == lastMovie.id && hasMorePages && !isPaginationLoading
    }
    
    func makeCardViewModel(for movie: Movie) -> MovieCardViewModel {
        MovieCardViewModelFactory.makeMovieCardViewModel(for: movie)
    }
}
