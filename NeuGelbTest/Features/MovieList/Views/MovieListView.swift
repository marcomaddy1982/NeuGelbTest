//
//  MovieListView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 23.03.26.
//

import SwiftUI

struct MovieListView: View {
    @State private var viewModel = MovieListViewModelFactory.makeMovieListViewModel()

    var body: some View {
        @Bindable var viewModel = viewModel
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
        .navigationTitle("movieList.navigationTitle")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $viewModel.showSettings) {
            SettingsView()
        }
        .task(id: viewModel.state) {
            if case .loading = viewModel.state {
                await viewModel.loadMovies()
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieListView()
    }
}
