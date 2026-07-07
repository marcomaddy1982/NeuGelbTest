import Foundation

nonisolated struct MovieList: Decodable, Sendable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let isFavourite: Bool
    let createdAt: String
    let itemCount: Int
}
