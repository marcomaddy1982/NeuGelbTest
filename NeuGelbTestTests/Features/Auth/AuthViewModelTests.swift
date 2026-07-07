import Testing
import Foundation
import SwiftData
@testable import NeuGelbTest

@Suite("AuthViewModel Tests")
@MainActor
struct AuthViewModelTests {

    private func makeSUT(accessToken: String? = nil, refreshToken: String? = nil) throws -> (AuthViewModel, MockAuthService, MockSessionManager) {
        let authService = MockAuthService()
        let sessionManager = MockSessionManager()
        sessionManager.accessToken = accessToken
        sessionManager.refreshToken = refreshToken
        let modelContainer = try TestModelContainer.create()
        let viewModel = AuthViewModel(authService: authService, sessionManager: sessionManager, modelContainer: modelContainer)
        return (viewModel, authService, sessionManager)
    }

    @Test("init sets loggedIn state when access token exists")
    func test_init_loggedIn_whenAccessTokenExists() throws {
        let (sut, _, _) = try makeSUT(accessToken: "some_token")

        #expect(sut.state == .loggedIn)
    }

    @Test("init sets loggedOut state when no access token")
    func test_init_loggedOut_whenNoAccessToken() throws {
        let (sut, _, _) = try makeSUT()

        #expect(sut.state == .loggedOut)
    }

    @Test("logout sets loggedOut state")
    func test_logout_setsLoggedOutState() async throws {
        let (sut, _, _) = try makeSUT(accessToken: "some_token", refreshToken: "some_refresh")

        await sut.logout()

        #expect(sut.state == .loggedOut)
    }

    @Test("logout clears session")
    func test_logout_clearsSession() async throws {
        let (sut, _, sessionManager) = try makeSUT(accessToken: "some_token", refreshToken: "some_refresh")

        await sut.logout()

        #expect(sessionManager.deleteSessionCallCount == 1)
        #expect(sessionManager.accessToken == nil)
    }

    @Test("logout calls auth service logout")
    func test_logout_callsAuthServiceLogout() async throws {
        let (sut, authService, _) = try makeSUT(accessToken: "some_token", refreshToken: "some_refresh")

        await sut.logout()

        #expect(authService.logoutCallCount == 1)
    }
}
