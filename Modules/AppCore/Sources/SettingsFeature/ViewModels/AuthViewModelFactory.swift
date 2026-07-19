import AppFeatures
import Foundation
import SwiftData

@MainActor
final class AuthViewModelFactory {
    @Injected<AuthServiceProtocol> var authService: any AuthServiceProtocol
    @Injected<SessionManagerProtocol> var sessionManager: any SessionManagerProtocol
    @Injected<ModelContainer> var modelContainer: ModelContainer

    static func makeAuthViewModel() -> AuthViewModel {
        let factory = AuthViewModelFactory()
        return AuthViewModel(
            authService: factory.authService,
            sessionManager: factory.sessionManager,
            modelContainer: factory.modelContainer
        )
    }
}
