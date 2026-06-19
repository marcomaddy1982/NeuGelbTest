import Foundation

nonisolated struct KinoListItem: Decodable, Sendable, Identifiable {
    let id: Int
    let tmdbMovieId: Int
    let createdAt: String
}
