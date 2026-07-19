import Testing
import TestSupport
import Foundation
@testable import AuthFeature

@Suite("LoginViewModel Tests")
@MainActor
struct LoginViewModelTests {

    private func makeSUT() -> (LoginViewModel, MockAuthService, MockSessionManager) {
        let authService = MockAuthService()
        let sessionManager = MockSessionManager()
        let viewModel = LoginViewModel(authService: authService, sessionManager: sessionManager)
        return (viewModel, authService, sessionManager)
    }

    @Test("login success sets success state")
    func test_login_success_setsSuccessState() async {
        let (sut, _, _) = makeSUT()
        sut.email = "test@example.com"
        sut.password = "Password1"

        await sut.login()

        #expect(sut.loginState == .success)
    }

    @Test("login success saves tokens to session")
    func test_login_success_savesTokensToSession() async {
        let (sut, _, sessionManager) = makeSUT()
        sut.email = "test@example.com"
        sut.password = "Password1"

        await sut.login()

        #expect(sessionManager.lastSavedAccessToken == "mock_access_token")
        #expect(sessionManager.lastSavedRefreshToken == "mock_refresh_token")
    }

    @Test("login failure sets error state")
    func test_login_failure_setsErrorState() async {
        let (sut, authService, _) = makeSUT()
        authService.shouldThrow = true
        sut.email = "test@example.com"
        sut.password = "Password1"

        await sut.login()

        if case .error = sut.loginState { } else {
            Issue.record("Expected error state")
        }
    }

    @Test("login calls auth service with correct credentials")
    func test_login_callsAuthServiceWithCorrectCredentials() async {
        let (sut, authService, _) = makeSUT()
        sut.email = "test@example.com"
        sut.password = "Password1"

        await sut.login()

        #expect(authService.loginCallCount == 1)
        #expect(authService.lastLoginEmail == "test@example.com")
    }
}
