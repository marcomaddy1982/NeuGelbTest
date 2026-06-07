import Foundation

nonisolated struct AuthSession: Decodable, Sendable {
    let success: Bool
    let sessionId: String

    enum CodingKeys: String, CodingKey {
        case success
        case sessionId = "session_id"
    }
}
