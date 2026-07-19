import Foundation

public nonisolated struct CheckFavouriteResponse: Decodable, Sendable {
    public let isFavourite: Bool
}
