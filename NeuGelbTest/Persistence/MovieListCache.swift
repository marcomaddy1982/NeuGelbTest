import SwiftData
import Foundation

@MainActor
final class MovieListCache {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func getMovies(page: Int, cacheDuration: TimeInterval) throws -> MovieListResponse? {
        let metadataDescriptor = FetchDescriptor<MoviePageMetadata>(
            predicate: #Predicate { $0.pageNumber == page }
        )
        guard let metadata = try modelContext.fetch(metadataDescriptor).first else {
            return nil
        }

        guard metadata.isValid(cacheDuration: cacheDuration) else {
            return nil
        }

        let movieDescriptor = FetchDescriptor<MovieEntity>(
            predicate: #Predicate { $0.pageNumber == page },
            sortBy: [SortDescriptor(\.order)]
        )
        let entities = try modelContext.fetch(movieDescriptor)

        return MovieListResponse(
            page: metadata.pageNumber,
            results: entities.map { $0.toMovie() },
            totalPages: metadata.totalPages,
            totalResults: metadata.totalResults
        )
    }

    func saveMovies(_ response: MovieListResponse, page: Int) throws {
        let metadata = MoviePageMetadata(
            pageNumber: response.page,
            totalPages: response.totalPages,
            totalResults: response.totalResults
        )
        modelContext.insert(metadata)
        
        // Save all movies with order index to preserve API order
        for (index, movie) in response.results.enumerated() {
            let entity = MovieEntity(from: movie, pageNumber: page, order: index)
            modelContext.insert(entity)
        }
        
        try modelContext.save()
    }
    
    func clearAll() throws {
        try modelContext.delete(model: MovieEntity.self)
        try modelContext.delete(model: MoviePageMetadata.self)
    }
}
