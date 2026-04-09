//
//  MovieDetailView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import SwiftUI

struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel
    
    init(movie: Movie) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModelFactory.makeMovieDetailViewModel(for: movie))
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                MovieDetailLoadingView()
                
            case .success:
                MovieDetailSuccessView(viewModel: viewModel)
                
            case .error(let errorMessage):
                ErrorStateView(errorMessage: errorMessage, onRetry: {
                    await viewModel.loadMovieDetail()
                })
            }
        }
        .navigationTitle("Movie Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMovieDetail()
        }
        .onAppear {
            Task {
                await viewModel.saveRecentlyViewed()
            }
        }
    }
}

#Preview {
    let movie = Movie(
        tmdbId: 278,
        title: "The Shawshank Redemption",
        posterPath: "/test.jpg",
        voteAverage: 9.3,
        overview: "Two imprisoned men bond over a number of years.",
        releaseDate: "1994-09-23"
    )
    
    NavigationStack {
        MovieDetailView(movie: movie)
    }
}
