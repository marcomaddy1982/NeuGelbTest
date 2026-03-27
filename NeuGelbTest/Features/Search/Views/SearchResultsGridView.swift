//
//  SearchResultsGridView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 25.03.26.
//

import SwiftUI

struct SearchResultsGridView: View {
    let searchResults: [Movie]
    let onMovieSelected: (Int) -> Void
    let shouldLoadNextPage: (Movie) -> Bool
    let onNextPageLoad: () -> Void
    let imageService: any ImageServiceProtocol
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                VStack(spacing: 16) {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 16
                    ) {
                        ForEach(searchResults, id: \.id) { movie in
                            Button(action: {
                                onMovieSelected(movie.tmdbId)
                            }) {
                                MovieCardView(viewModel: MovieCardViewModel(movie: movie, imageService: imageService))
                            }
                            .onAppear {
                                if shouldLoadNextPage(movie) {
                                    onNextPageLoad()
                                }
                            }
                        }
                    }
                }
                .padding(16)
            }
        }
    }
}

#Preview {
    do {
        let config = try NetworkConfig()
        let networkClient = NetworkClient(config: config)
        let imageService = ImageService(networkClient: networkClient, imageBaseURL: config.imageBaseURL)
        
        return SearchResultsGridView(
            searchResults: [
                Movie(
                    tmdbId: 550,
                    title: "Fight Club",
                    posterPath: "/a26cQPRhJPX6GbWfQbvZdrrVzqa.jpg",
                    voteAverage: 8.4,
                    overview: "A ticking-time-bomb incarcerates a man in an everchanging prison cell.",
                    releaseDate: "1999-10-15"
                ),
                Movie(
                    tmdbId: 278,
                    title: "The Shawshank Redemption",
                    posterPath: "/q6725aR8Zs4IwGMAneuEYkAQCgd.jpg",
                    voteAverage: 9.3,
                    overview: "Two imprisoned men bond over a number of years.",
                    releaseDate: "1994-10-14"
                ),
                Movie(
                    tmdbId: 680,
                    title: "Pulp Fiction",
                    posterPath: "/dM2w364MScsjFjS91ChzjrQj82a.jpg",
                    voteAverage: 8.9,
                    overview: "The lives of two mob hitmen, a boxer, a gangster and his wife.",
                    releaseDate: "1994-10-14"
                ),
                Movie(
                    tmdbId: 238,
                    title: "The Godfather",
                    posterPath: "/3bhkrj58Vtu7enYsRolD1fZQeQA.jpg",
                    voteAverage: 9.2,
                    overview: "The aging patriarch of an organized crime dynasty transfers control.",
                    releaseDate: "1972-03-24"
                )
            ],
            onMovieSelected: { movieId in
                print("Selected movie: \(movieId)")
            },
            shouldLoadNextPage: { _ in false },
            onNextPageLoad: {
                print("Loading next page")
            },
            imageService: imageService
        )
    } catch {
        return AnyView(Text("Preview error"))
    }
}
