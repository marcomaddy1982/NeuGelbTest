import Foundation
import SwiftData

@MainActor
final class AuthViewModelFactory {
    @Injected<SessionManagerProtocol> var sessionManager: any SessionManagerProtocol
    @Injected<ModelContainer> var modelContainer: ModelContainer

    static func makeAuthViewModel() -> AuthViewModel {
        let factory = AuthViewModelFactory()
        return AuthViewModel(
            sessionManager: factory.sessionManager,
            modelContainer: factory.modelContainer
        )
    }
}
