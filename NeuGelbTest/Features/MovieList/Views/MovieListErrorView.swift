//
//  MovieListErrorView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 27.03.26.
//

import SwiftUI

struct MovieListErrorView: View {
    let errorMessage: String
    let viewModel: MovieListViewModel
    
    var body: some View {
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
                    await viewModel.loadMovies()
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
    MovieListErrorView(
        errorMessage: "Failed to load movies",
        viewModel: MovieListViewModelFactory.makeMovieListViewModel()
    )
}
