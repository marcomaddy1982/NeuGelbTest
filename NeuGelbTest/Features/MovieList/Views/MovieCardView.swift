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
                        .labelStyle()
                        .foregroundColor(AppColors.primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 0)

                    Label(viewModel.voteAverage, systemImage: "star.fill")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.accent)

                    Text(viewModel.releaseDate)
                        .font(AppFonts.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .padding(8)

                Spacer()
            }
            .background(AppColors.backgroundLight)
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
            PlaceholderImageView(height: 140, imageName: "film.fill")

        case .loading:
            VStack {
                ProgressView()
                    .tint(AppColors.primary)
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .background(AppColors.backgroundNeutral)
            
        case .success(let image):
            image
                .resizable()
                .scaledToFill()
                .frame(height: 140)
                .clipped()
            
        case .error:
            PlaceholderImageView(height: 140, imageName: "film.fill")
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
