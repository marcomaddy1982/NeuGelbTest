//
//  MovieListSuccessView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 27.03.26.
//

import SwiftUI

struct MovieListSuccessView: View {
    let movies: [Movie]
    let viewModel: MovieListViewModel
    
    private let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 16) {
                ForEach(movies, id: \.id) { movie in
                    MovieCardView(viewModel: viewModel.makeCardViewModel(for: movie))
                        .onAppear {
                            if viewModel.shouldLoadNextPage(for: movie) {
                                Task {
                                    await viewModel.loadNextPage()
                                }
                            }
                        }
                }
                
                if viewModel.isPaginationLoading {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Loading more movies...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .gridCellUnsizedAxes([.horizontal])
                    .padding()
                }
            }
            .padding()
        }
    }
}

#Preview {
    MovieListSuccessView(
        movies: [],
        viewModel: MovieListViewModelFactory.makeMovieListViewModel()
    )
}
