import Foundation

nonisolated struct KinoList: Decodable, Sendable, Identifiable {
    let id: Int
    let name: String
    let isFavourite: Bool
    let createdAt: String
}
