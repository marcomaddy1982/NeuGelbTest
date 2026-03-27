//
//  SearchView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import SwiftUI

@MainActor
struct SearchView: View {
    @StateObject private var viewModel = SearchViewModelFactory.makeSearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                switch viewModel.state {
                case .empty:
                    SearchEmptyStateView()
                case .loading:
                    ProgressView()
                        .frame(maxHeight: .infinity)
                case .success:
                    SearchResultsGridView(
                        searchResults: viewModel.searchResults,
                        onMovieSelected: { movieId in
                            viewModel.selectMovie(movieId)
                        },
                        shouldLoadNextPage: { movie in
                            viewModel.shouldLoadNextPage(for: movie)
                        },
                        onNextPageLoad: {
                            viewModel.loadNextPage()
                        },
                        imageService: viewModel.imageService
                    )
                case .error(let message):
                    SearchErrorStateView(message: message)
                }
            }
            .navigationTitle("Search Movies")
            .searchable(
                text: $viewModel.searchQuery,
                prompt: "Search movies..."
            )
            .navigationDestination(isPresented: .constant(viewModel.selectedMovieId != nil)) {
                if let movieId = viewModel.selectedMovieId,
                   let movie = viewModel.searchResults.first(where: { $0.tmdbId == movieId }) {
                    MovieDetailView(movie: movie)
                        .onDisappear {
                            viewModel.clearSelection()
                        }
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
