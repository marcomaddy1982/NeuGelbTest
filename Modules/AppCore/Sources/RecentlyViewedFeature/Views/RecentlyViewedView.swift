//
//  RecentlyViewedView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 27.03.26.
//

import AppFeatures
import DesignSystem
import SwiftData
import SwiftUI

@MainActor
public struct RecentlyViewedView: View {
    @State private var viewModel = RecentlyViewedViewModelFactory.makeRecentlyViewedViewModel()
    @Injected<ModelContainer> var modelContainer: ModelContainer

    public init() {}

    public var body: some View {
        @Bindable var viewModel = viewModel
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
        .modelContext(ModelContext(modelContainer))
        .toolbar {
            if case .success = viewModel.state {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedStringKey("recentlyViewed.clearHistory")) {
                        viewModel.requestClearAll()
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .alert(
            LocalizedStringKey("recentlyViewed.clearHistory.confirmTitle"),
            isPresented: $viewModel.showClearConfirmation
        ) {
            Button(LocalizedStringKey("recentlyViewed.clearHistory.confirmButton"), role: .destructive) {
                Task { await viewModel.clearAll() }
            }
            Button("common.cancel", role: .cancel) {}
        } message: {
            Text("recentlyViewed.clearHistory.confirmMessage")
        }
        .task {
            await viewModel.loadRecentlyViewed()
        }
    }
}

#Preview {
    RecentlyViewedView()
}


