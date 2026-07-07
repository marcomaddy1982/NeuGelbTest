import Foundation
@testable import NeuGelbTest

final class MockAuthService: AuthServiceProtocol {
    var registerCallCount: Int = 0
    var loginCallCount: Int = 0
    var logoutCallCount: Int = 0
    var lastRegisterEmail: String?
    var lastLoginEmail: String?

    var mockAuthTokenResponse: AuthTokenResponse = AuthTokenResponse(
        accessToken: "mock_access_token",
        refreshToken: "mock_refresh_token",
        user: AuthUser(id: 1, email: "test@example.com", name: "Test User", phoneNumber: "+391234567890")
    )

    var shouldThrow: Bool = false

    func register(email: String, password: String, name: String, phoneNumber: String) async throws -> AuthTokenResponse {
        registerCallCount += 1
        lastRegisterEmail = email
        if shouldThrow { throw MockAuthError.generic }
        return mockAuthTokenResponse
    }

    func login(email: String, password: String) async throws -> AuthTokenResponse {
        loginCallCount += 1
        lastLoginEmail = email
        if shouldThrow { throw MockAuthError.generic }
        return mockAuthTokenResponse
    }

    func logout(refreshToken: String) async throws {
        logoutCallCount += 1
        if shouldThrow { throw MockAuthError.generic }
    }
}

private enum MockAuthError: Error {
    case generic
}
