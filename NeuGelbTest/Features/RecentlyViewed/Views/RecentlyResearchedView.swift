//
//  RecentlyResearchedView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 27.03.26.
//

import SwiftUI
import SwiftData

struct RecentlyResearchedView: View {
    @Query(sort: \RecentlyViewedMovie.viewedAtTimestamp, order: .reverse)
    var recentlyViewedMovies: [RecentlyViewedMovie]
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 160), spacing: 16)
                ],
                spacing: 16
            ) {
                ForEach(recentlyViewedMovies, id: \.tmdbId) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie.toMovie())) {
                        MovieCardView(viewModel: MovieCardViewModelFactory.makeMovieCardViewModel(for: movie.toMovie()))
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    RecentlyResearchedView()
        .modelContainer(for: RecentlyViewedMovie.self, inMemory: true)
}

