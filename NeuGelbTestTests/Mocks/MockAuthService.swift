import Foundation
@testable import NeuGelbTest

final class MockAuthService: AuthServiceProtocol {
    var requestTokenCallCount: Int = 0
    var createSessionCallCount: Int = 0
    var deleteSessionCallCount: Int = 0
    var registerCallCount: Int = 0

    var lastCreateSessionRequestToken: String?
    var lastDeleteSessionId: String?
    var lastRegisterEmail: String?

    var mockRequestToken: RequestToken = RequestToken(success: true, expiresAt: "2024-01-01 12:00:00 UTC", requestToken: "mock_request_token")
    var mockAuthSession: AuthSession = AuthSession(success: true, sessionId: "mock_session_id")
    var mockDeleteSessionResponse: DeleteSessionResponse = DeleteSessionResponse(success: true)
    var mockAuthTokenResponse: AuthTokenResponse = AuthTokenResponse(
        accessToken: "mock_access_token",
        refreshToken: "mock_refresh_token",
        user: AuthUser(id: 1, email: "test@example.com", name: "Test User", phoneNumber: "+391234567890")
    )

    var shouldThrow: Bool = false

    func requestToken() async throws -> RequestToken {
        requestTokenCallCount += 1
        if shouldThrow { throw MockAuthError.generic }
        return mockRequestToken
    }

    func createSession(requestToken: String) async throws -> AuthSession {
        createSessionCallCount += 1
        lastCreateSessionRequestToken = requestToken
        if shouldThrow { throw MockAuthError.generic }
        return mockAuthSession
    }

    func deleteSession(sessionId: String) async throws -> DeleteSessionResponse {
        deleteSessionCallCount += 1
        lastDeleteSessionId = sessionId
        if shouldThrow { throw MockAuthError.generic }
        return mockDeleteSessionResponse
    }

    func authorizationURL(for requestToken: String) -> URL {
        URL(string: "https://mock.themoviedb.org/authenticate/\(requestToken)")!
    }

    func register(email: String, password: String, name: String, phoneNumber: String) async throws -> AuthTokenResponse {
        registerCallCount += 1
        lastRegisterEmail = email
        if shouldThrow { throw MockAuthError.generic }
        return mockAuthTokenResponse
    }
}

private enum MockAuthError: Error {
    case generic
}
