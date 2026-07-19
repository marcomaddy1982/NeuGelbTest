import Foundation

public nonisolated struct MovieList: Decodable, Sendable, Identifiable, Equatable, Hashable {
    public let id: Int
    public let name: String
    public let isFavourite: Bool
    public let createdAt: String
    public let itemCount: Int
}
