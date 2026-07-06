import Foundation

nonisolated struct AuthTokenResponse: Decodable, Sendable {
    let accessToken: String
    let refreshToken: String
    let user: AuthUser
}
