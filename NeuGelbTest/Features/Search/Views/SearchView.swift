//
//  SearchView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import SwiftUI

@MainActor
struct SearchView: View {
    @State private var viewModel = SearchViewModelFactory.makeSearchViewModel()


    var body: some View {
        @Bindable var viewModel = viewModel
        VStack(spacing: 0) {
            switch viewModel.state {
            case .empty:
                EmptyStateView(
                    icon: "magnifyingglass",
                    title: "search.empty.title",
                    message: "search.empty.subtitle"
                )
                .offset(y: LayoutConstants.searchBarOffset)
            case .loading:
                ProgressView()
                    .frame(maxHeight: .infinity)
            case .success:
                SearchResultsGridView(
                    searchResults: viewModel.searchResults,
                    shouldLoadNextPage: { movie in
                        viewModel.shouldLoadNextPage(for: movie)
                    },
                    onNextPageLoad: {
                        viewModel.loadNextPage()
                    },
                    imageService: viewModel.imageService
                )
            case .error(let message):
                ErrorStateView(
                    errorMessage: message,
                    onRetry: {
                        viewModel.performSearch(query: viewModel.searchQuery)
                    }
                )
            }
        }
        .navigationTitle("search.navigationTitle")
        .searchable(
            text: $viewModel.searchQuery,
            prompt: Text("search.placeholder")
        )
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
    .environment(TabRouter())
}
