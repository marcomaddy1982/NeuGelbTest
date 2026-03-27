import SwiftData
import Foundation

class PersistenceFactory {
    static func createModelContainer() throws -> ModelContainer {
        let container = try ModelContainer(
            for: MovieEntity.self, MoviePageMetadata.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: false)
        )
        return container
    }
}
