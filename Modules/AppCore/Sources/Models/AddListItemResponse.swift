import Foundation

public nonisolated struct AddListItemResponse: Decodable, Sendable {
    public let tmdbMovieId: Int
}
