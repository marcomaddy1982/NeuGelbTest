import Foundation

nonisolated struct CheckFavouriteResponse: Decodable, Sendable {
    let isFavourite: Bool
}
