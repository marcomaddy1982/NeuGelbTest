import AppFeatures
import Foundation
import Models

public final class MockAuthService: AuthServiceProtocol {
    public var registerCallCount: Int = 0
    public var loginCallCount: Int = 0
    public var logoutCallCount: Int = 0
    public var lastRegisterEmail: String?
    public var lastLoginEmail: String?

    public var mockAuthTokenResponse: AuthTokenResponse = AuthTokenResponse(
        accessToken: "mock_access_token",
        refreshToken: "mock_refresh_token",
        user: AuthUser(id: 1, email: "test@example.com", name: "Test User", phoneNumber: "+391234567890")
    )

    public var shouldThrow: Bool = false

    public init() {}

    public func register(email: String, password: String, name: String, phoneNumber: String) async throws -> AuthTokenResponse {
        registerCallCount += 1
        lastRegisterEmail = email
        if shouldThrow { throw MockAuthError.generic }
        return mockAuthTokenResponse
    }

    public func login(email: String, password: String) async throws -> AuthTokenResponse {
        loginCallCount += 1
        lastLoginEmail = email
        if shouldThrow { throw MockAuthError.generic }
        return mockAuthTokenResponse
    }

    public func logout(refreshToken: String) async throws {
        logoutCallCount += 1
        if shouldThrow { throw MockAuthError.generic }
    }
}

private enum MockAuthError: Error {
    case generic
}
