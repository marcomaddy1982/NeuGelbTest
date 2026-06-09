import Foundation

@MainActor
final class LoginViewModelFactory {
    @Injected<AuthServiceProtocol> var authService: any AuthServiceProtocol
    @Injected<SessionManagerProtocol> var sessionManager: any SessionManagerProtocol

    static func makeLoginViewModel() -> LoginViewModel {
        let factory = LoginViewModelFactory()
        return LoginViewModel(authService: factory.authService, sessionManager: factory.sessionManager)
    }
}
