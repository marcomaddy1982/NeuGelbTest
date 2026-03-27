//
//  MovieDetailViewModel.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import Foundation
import os
import Combine

enum MovieDetailViewState {
    case loading
    case success(MovieDetail)
    case error(String)
}

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var state: MovieDetailViewState = .loading
    
    private let movieService: MovieServiceProtocol
    private(set) var imageService: ImageServiceProtocol
    private let recentlyViewedRepository: RecentlyViewedRepositoryProtocol

    private let backdropImageSize = "w780"
    
    let movie: Movie
    
    init(movie: Movie, movieService: MovieServiceProtocol, imageService: ImageServiceProtocol, recentlyViewedRepository: RecentlyViewedRepositoryProtocol) {
        self.movie = movie
        self.movieService = movieService
        self.imageService = imageService
        self.recentlyViewedRepository = recentlyViewedRepository
    }
    
    func loadMovieDetail() async {
        state = .loading
        
        do {
            let detail = try await movieService.fetchMovieDetail(id: movie.tmdbId)
            self.state = .success(detail)
            print("🎬 Loaded movie detail for: \(detail.title))")
        } catch {
            let errorMessage = "Failed to load movie details: \(error.localizedDescription)"
            self.state = .error(errorMessage)
            print("❌ Failed to load movie detail: \(error.localizedDescription)")
        }
    }
    
    func saveRecentlyViewed() async {
        do {
            try await recentlyViewedRepository.saveMovie(movie)
            print("💾 Saved movie to recently viewed: \(movie.title)")
        } catch {
            print("❌ Failed to save recently viewed movie: \(error.localizedDescription)")
        }
    }
    
    private var detail: MovieDetail? {
        if case .success(let detail) = state {
            return detail
        }
        return nil
    }
    
    var hasTagline: Bool { detail?.tagline?.isEmpty == false }
    var hasGenres: Bool { detail?.genres.isEmpty == false }
    var hasProductionCompanies: Bool { detail?.productionCompanies.isEmpty == false }
    var hasProductionCountries: Bool { detail?.productionCountries.isEmpty == false }
    var hasSpokenLanguages: Bool { detail?.spokenLanguages.isEmpty == false }
    var hasFinancialInfo: Bool { (detail?.budget ?? 0) > 0 || (detail?.revenue ?? 0) > 0 }
    var hasBackdrop: Bool { detail?.backdropPath?.isEmpty == false     }
    
    var title: String { detail?.title ?? "Unknown" }
    
    var voteAverageFormatted: String {
        guard let avg = detail?.voteAverage else { return "N/A" }
        return String(format: "%.1f", avg)
    }
    
    var releaseDate: String {
        (detail?.releaseDate?.asFormattedReleaseDate()) ?? "N/A"
    }
    
    var runtime: String {
        detail?.runtime?.asFormattedRuntime() ?? "N/A"
    }
    
    var overview: String {
        guard let overview = detail?.overview, !overview.isEmpty else {
            return "No overview available"
        }
        return overview
    }
    
    var tagline: String {
        detail?.tagline ?? ""
    }
    
    var budget: String {
        (detail?.budget ?? 0).asFormattedCurrency() ?? "N/A"
    }
    
    var revenue: String {
        (detail?.revenue ?? 0).asFormattedCurrency() ?? "N/A"
    }
    
    var genres: [Genre] {
        detail?.genres ?? []
    }
    
    var productionCompanies: [ProductionCompany] {
        detail?.productionCompanies ?? []
    }
    
    var productionCountries: [ProductionCountry] {
        detail?.productionCountries ?? []
    }
    
    var spokenLanguages: [SpokenLanguage] {
        detail?.spokenLanguages ?? []
    }
    
    var backdropPath: String? {
        detail?.backdropPath
    }
    
    var backdropImageURL: URL? {
        guard let backdropPath = detail?.backdropPath else { return nil }
        return imageService.buildImageURL(path: backdropPath, size: backdropImageSize)
    }
}
