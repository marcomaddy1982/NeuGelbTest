//
//  RecentlyViewedView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 27.03.26.
//

import SwiftUI
import SwiftData

@MainActor
struct RecentlyViewedView: View {
    @StateObject private var viewModel = RecentlyViewedViewModelFactory.makeRecentlyViewedViewModel()
    @Injected<ModelContainer> var modelContainer: ModelContainer
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                switch viewModel.state {
                case .empty:
                    EmptyStateView(
                        icon: "clock.fill",
                        title: "recentlyViewed.empty.title",
                        message: "recentlyViewed.empty.subtitle"
                    )
                case .success:
                    RecentlyResearchedView()
                case .error(let message):
                    ErrorStateView(
                        errorMessage: message,
                        onRetry: {
                            await viewModel.loadRecentlyViewed()
                        }
                    )
                }
            }
            .navigationTitle("recentlyViewed.navigationTitle")
        }
        .modelContext(ModelContext(modelContainer))
        .task {
            await viewModel.loadRecentlyViewed()
        }
    }
}

#Preview {
    RecentlyViewedView()
}


