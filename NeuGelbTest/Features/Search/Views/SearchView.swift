//
//  SearchView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import SwiftUI

@MainActor
struct SearchView: View {
    @State private var viewModel = SearchViewModelFactory.makeSearchViewModel()

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            VStack(spacing: 0) {
                switch viewModel.state {
                case .empty:
                    EmptyStateView(
                        icon: "magnifyingglass",
                        title: "search.empty.title",
                        message: "search.empty.subtitle"
                    )
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
                    ErrorStateView(
                        errorMessage: message,
                        onRetry: {
                            viewModel.performSearch(query: viewModel.searchQuery)
                        }
                    )
                }
            }
            .navigationTitle("search.navigationTitle")
            .searchable(
                text: $viewModel.searchQuery,
                prompt: Text("search.placeholder")
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
