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
                    RecentlyViewedEmptyStateView()
                case .success:
                    RecentlyResearchedView()
                case .error(let message):
                    RecentlyViewedErrorStateView(message: message)
                }
            }
            .navigationTitle("Recently Viewed")
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


