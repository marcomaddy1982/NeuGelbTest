import Foundation

public nonisolated struct AuthTokenResponse: Decodable, Sendable {
    public let accessToken: String
    public let refreshToken: String
    public let user: AuthUser

    public init(accessToken: String, refreshToken: String, user: AuthUser) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.user = user
    }
}
