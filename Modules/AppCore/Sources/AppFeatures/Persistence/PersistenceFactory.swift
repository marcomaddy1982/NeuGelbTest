import SwiftData
import Foundation

public class PersistenceFactory {
    public static func createModelContainer() throws -> ModelContainer {
        let container = try ModelContainer(
            for: MovieEntity.self, MoviePageMetadata.self, RecentlyViewedMovie.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: false)
        )
        return container
    }
}
