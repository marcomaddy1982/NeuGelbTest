import Foundation

@MainActor
final class AuthViewModelFactory {
    @Injected<AuthServiceProtocol> var authService: any AuthServiceProtocol
    @Injected<SessionManagerProtocol> var sessionManager: any SessionManagerProtocol

    static func makeAuthViewModel() -> AuthViewModel {
        let factory = AuthViewModelFactory()
        return AuthViewModel(authService: factory.authService, sessionManager: factory.sessionManager)
    }
}
