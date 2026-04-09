//
//  RecentlyViewedViewModelFactory.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 27.03.26.
//

import Foundation

@MainActor
final class RecentlyViewedViewModelFactory {
    @Injected<RecentlyViewedRepositoryProtocol> var recentlyViewedRepository
    
    static func makeRecentlyViewedViewModel() -> RecentlyViewedViewModel {
        let factory = RecentlyViewedViewModelFactory()
        return RecentlyViewedViewModel(recentlyViewedRepository: factory.recentlyViewedRepository)
    }
}

