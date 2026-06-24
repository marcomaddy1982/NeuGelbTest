import Foundation

nonisolated struct AddListItemResponse: Decodable, Sendable {
    let tmdbMovieId: Int
}
