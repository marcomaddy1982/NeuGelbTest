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
@MainActor
final class AuthViewModel {
    var state: AuthState

    private let sessionManager: any SessionManagerProtocol
    private let modelContainer: ModelContainer

    init(
        sessionManager: any SessionManagerProtocol,
        modelContainer: ModelContainer
    ) {
        self.sessionManager = sessionManager
        self.modelContainer = modelContainer
        self.state = sessionManager.accessToken != nil ? .loggedIn : .loggedOut
    }

    func logout() async {
        state = .loading
        clearPersistentData()
        try? sessionManager.deleteSession()
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
