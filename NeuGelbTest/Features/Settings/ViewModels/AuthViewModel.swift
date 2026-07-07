import Foundation
import Observation
import SwiftData

enum AuthState: Equatable {
    case loggedOut
    case loading
    case loggedIn
    case error(String)
}

@Observable
final class AuthViewModel {
    var state: AuthState

    private let authService: any AuthServiceProtocol
    private let sessionManager: any SessionManagerProtocol
    private let modelContainer: ModelContainer

    init(
        authService: any AuthServiceProtocol,
        sessionManager: any SessionManagerProtocol,
        modelContainer: ModelContainer
    ) {
        self.authService = authService
        self.sessionManager = sessionManager
        self.modelContainer = modelContainer
        self.state = sessionManager.accessToken != nil ? .loggedIn : .loggedOut
    }

    func logout() async {
        state = .loading
        let token = sessionManager.refreshToken
        clearPersistentData()
        try? sessionManager.deleteSession()
        if let token {
            try? await authService.logout(refreshToken: token)
        }
        state = .loggedOut
    }

    private func clearPersistentData() {
        let context = ModelContext(modelContainer)
        try? context.delete(model: MovieEntity.self)
        try? context.delete(model: MoviePageMetadata.self)
        try? context.delete(model: RecentlyViewedMovie.self)
        try? context.save()
    }
}
