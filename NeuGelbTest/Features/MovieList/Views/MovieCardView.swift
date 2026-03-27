//
//  MovieCardView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 23.03.26.
//

import SwiftUI

struct MovieCardView: View {
    @StateObject var viewModel: MovieCardViewModel
    
    var body: some View {
        NavigationLink(destination: MovieDetailView(movie: viewModel.movie)) {
            VStack(alignment: .leading, spacing: 0) {
                posterImageSection
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.title)
                        .font(.system(size: 15, weight: .semibold))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 0)

                    Label(viewModel.voteAverage, systemImage: "star.fill")
                        .font(.caption)
                        .foregroundColor(.orange)

                    Text(viewModel.releaseDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .padding(8)

                Spacer()
            }
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .frame(height: 245)
            .onAppear {
                viewModel.loadImage()
            }
            .onDisappear {
                viewModel.cancelImageLoad()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private var posterImageSection: some View {
        switch viewModel.imageState {
        case .idle:
            VStack {
                Image(systemName: "film.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray5))

        case .loading:
            VStack {
                ProgressView()
                    .tint(.blue)
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray5))
            
        case .success(let image):
            image
                .resizable()
                .scaledToFill()
                .frame(height: 140)
                .clipped()
            
        case .error:
            VStack {
                Image(systemName: "film.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray5))
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
    
    do {
        let config = try NetworkConfig()
        let networkClient = NetworkClient(config: config)
        let imageService = ImageService(networkClient: networkClient, imageBaseURL: config.imageBaseURL)
        let viewModel = MovieCardViewModel(movie: movie, imageService: imageService)
        
        return NavigationStack {
            MovieCardView(viewModel: viewModel)
                .padding()
        }
    } catch {
        return AnyView(Text("Preview error"))
    }
}
