//
//  MovieListView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 23.03.26.
//

import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModelFactory.makeMovieListViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    MovieListLoadingView()
                    
                case .success(let movies):
                    MovieListSuccessView(movies: movies, viewModel: viewModel)
                    
                case .error(let errorMessage):
                    ErrorStateView(errorMessage: errorMessage, onRetry: {
                        await viewModel.loadMovies()
                    })
                }
            }
            .navigationTitle("Movies")
            .task(id: viewModel.state) {
                // Only load movies if we're in the loading state (initial load)
                if case .loading = viewModel.state {
                    await viewModel.loadMovies()
                }
            }
        }
    }
}

#Preview {
    MovieListView()
}
