import Foundation

nonisolated struct AuthUser: Decodable, Sendable {
    let id: Int
    let email: String
    let name: String
    let phoneNumber: String?
}
