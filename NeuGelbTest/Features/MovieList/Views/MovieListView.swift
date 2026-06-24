//
//  MovieListView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 23.03.26.
//

import SwiftUI

struct MovieListView: View {
    @State private var viewModel = MovieListViewModelFactory.makeMovieListViewModel()
    @State private var listsRouter = ListsRouter()

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
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.showLists = true
                } label: {
                    Image(systemName: "list.bullet")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $viewModel.showLists) {
            NavigationStack(path: $listsRouter.path) {
                ListsView()
                    .navigationDestination(for: AppRoutePath.self) { routePath in
                        switch routePath.route {
                        case .listDetail(let list):
                            ListDetailView(viewModel: ListDetailViewModelFactory.makeListDetailViewModel(list: list))
                        case .movieDetail:
                            EmptyView()
                        }
                    }
            }
            .environment(listsRouter)
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
