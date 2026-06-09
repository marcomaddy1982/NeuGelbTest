//
//  AppRootView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import SwiftUI

struct AppRootView: View {
    @State private var viewModel = AppRootViewModelFactory.make()

    var body: some View {
        @Bindable var viewModel = viewModel
        if viewModel.isAuthenticated {
            TabView(selection: $viewModel.selectedTab) {
                NavigationStack(path: $viewModel.discoverRouter.path) {
                    MovieListView()
                        .navigationDestination(for: AppRoutePath.self) { routePath in
                            switch routePath.route {
                            case .movieDetail(let movie):
                                MovieDetailView(movie: movie)
                            }
                        }
                }
                .environment(viewModel.discoverRouter)
                .tabItem {
                    Label("tab.discover", systemImage: "list.bullet")
                }
                .tag(AppRootViewModel.Tab.discover)

                NavigationStack(path: $viewModel.searchRouter.path) {
                    SearchView()
                        .navigationDestination(for: AppRoutePath.self) { routePath in
                            switch routePath.route {
                            case .movieDetail(let movie):
                                MovieDetailView(movie: movie)
                            }
                        }
                }
                .environment(viewModel.searchRouter)
                .tabItem {
                    Label("tab.search", systemImage: "magnifyingglass")
                }
                .tag(AppRootViewModel.Tab.search)

                NavigationStack(path: $viewModel.recentlyViewedRouter.path) {
                    RecentlyViewedView()
                        .navigationDestination(for: AppRoutePath.self) { routePath in
                            switch routePath.route {
                            case .movieDetail(let movie):
                                MovieDetailView(movie: movie)
                            }
                        }
                }
                .environment(viewModel.recentlyViewedRouter)
                .tabItem {
                    Label("tab.recentlyViewed", systemImage: "clock")
                }
                .tag(AppRootViewModel.Tab.recentlyViewed)
            }
        } else {
            LoginView()
        }
    }
}

#Preview {
    AppRootView()
}
