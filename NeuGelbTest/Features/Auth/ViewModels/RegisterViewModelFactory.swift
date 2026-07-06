import Foundation

@MainActor
final class RegisterViewModelFactory {
    @Injected<AuthServiceProtocol> var authService: any AuthServiceProtocol
    @Injected<SessionManagerProtocol> var sessionManager: any SessionManagerProtocol

    static func make() -> RegisterViewModel {
        let factory = RegisterViewModelFactory()
        return RegisterViewModel(authService: factory.authService, sessionManager: factory.sessionManager)
    }
}
