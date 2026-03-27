//
//  RecentlyViewedCache.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 27.03.26.
//

import SwiftData
import Foundation

@MainActor
final class RecentlyViewedCache {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func getRecentlyViewed() throws -> [RecentlyViewedMovie] {
        let descriptor = FetchDescriptor<RecentlyViewedMovie>(
            sortBy: [SortDescriptor(\.viewedAtTimestamp, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    func saveMovie(_ movie: RecentlyViewedMovie) throws {
        modelContext.insert(movie)
        try modelContext.save()
    }
    
    func clearAll() throws {
        try modelContext.delete(model: RecentlyViewedMovie.self)
    }
}
