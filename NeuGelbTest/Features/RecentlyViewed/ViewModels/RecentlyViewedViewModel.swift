//
//  RecentlyViewedViewModel.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 27.03.26.
//

import Foundation
import Combine

enum RecentlyViewedViewState {
    case empty
    case success
    case error(String)
}

@MainActor
final class RecentlyViewedViewModel: ObservableObject {
    @Published var state: RecentlyViewedViewState = .empty
    
    private let recentlyViewedRepository: RecentlyViewedRepositoryProtocol
    
    init(recentlyViewedRepository: RecentlyViewedRepositoryProtocol) {
        self.recentlyViewedRepository = recentlyViewedRepository
    }
    func loadRecentlyViewed() async {
        do {
            let movies = try await recentlyViewedRepository.getRecentlyViewed()
            
            if movies.isEmpty {
                self.state = .empty
            } else {
                self.state = .success
            }
            print("🎬 Loaded \(movies.count) recently viewed movies")
        } catch {
            let errorMessage = "Failed to load recently viewed movies: \(error.localizedDescription)"
            self.state = .error(errorMessage)
            print("❌ \(errorMessage)")
        }
    }
}

