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
                loadingView
                
            case .success:
                successView
                
            case .error(let errorMessage):
                errorView(errorMessage)
            }
        }
        .navigationTitle("Movie Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMovieDetail()
        }
    }
    
    // MARK: - State Views
    
    @ViewBuilder
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading movie details...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    private var successView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Backdrop Image
                MovieDetailBackdropView(
                    backdropPath: viewModel.backdropPath,
                    imageService: viewModel.imageService
                )
                
                VStack(alignment: .leading, spacing: 16) {
                    // Header with title, vote average, and tagline
                    MovieDetailHeaderView(
                        title: viewModel.title,
                        voteAverage: viewModel.voteAverageFormatted,
                        tagline: viewModel.tagline,
                        hasTagline: viewModel.hasTagline
                    )
                    
                    Divider()
                    
                    // Metadata (release date, runtime)
                    MovieDetailMetadataView(
                        releaseDate: viewModel.releaseDate,
                        runtime: viewModel.runtime
                    )
                    
                    Divider()
                    
                    // Overview
                    MovieDetailOverviewView(overview: viewModel.overview)
                    
                    // Attributes (genres, production companies, countries, languages)
                    MovieDetailAttributesView(
                        hasGenres: viewModel.hasGenres,
                        genres: viewModel.genres,
                        hasProductionCompanies: viewModel.hasProductionCompanies,
                        productionCompanies: viewModel.productionCompanies,
                        hasProductionCountries: viewModel.hasProductionCountries,
                        productionCountries: viewModel.productionCountries,
                        hasSpokenLanguages: viewModel.hasSpokenLanguages,
                        spokenLanguages: viewModel.spokenLanguages
                    )
                    
                    // Financial info (budget, revenue)
                    if viewModel.hasFinancialInfo {
                        MovieDetailFinancialView(
                            budget: viewModel.budget,
                            revenue: viewModel.revenue
                        )
                    }
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    private func errorView(_ errorMessage: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.red)
            
            Text("Error")
                .font(.headline)
            
            Text(errorMessage)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                Task {
                    await viewModel.loadMovieDetail()
                }
            }) {
                Text("Try Again")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
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
