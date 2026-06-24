import Foundation

nonisolated struct MovieList: Decodable, Sendable, Identifiable, Equatable {
    let id: Int
    let name: String
    let isFavourite: Bool
    let createdAt: String
    let itemCount: Int
}
