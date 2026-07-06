import Foundation
import AuthenticationServices
import Observation
import UIKit
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

    private let authService: any AuthServiceProtocol
    private let sessionManager: any SessionManagerProtocol
    private let modelContainer: ModelContainer
    private let anchor = WebAuthAnchor()
    private var activeWebAuthSession: ASWebAuthenticationSession?

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

    // MARK: - Public

    func login() async {
        state = .loading
        do {
            let token = try await authService.requestToken()
            let url = authService.authorizationURL(for: token.requestToken)
            let callbackURL = try await performWebAuth(url: url)
            let approvedToken = try extractRequestToken(from: callbackURL)
            let session = try await authService.createSession(requestToken: approvedToken)
            try sessionManager.save(accessToken: session.sessionId, refreshToken: session.sessionId)
            state = .loggedIn
        } catch {
            let nsError = error as NSError
            if nsError.domain == ASWebAuthenticationSessionErrorDomain,
               nsError.code == ASWebAuthenticationSessionError.canceledLogin.rawValue {
                state = .loggedOut
            } else {
                state = .error(error.localizedDescription)
            }
        }
    }

    func logout() async {
        state = .loading
        if let sessionId = sessionManager.accessToken {
            _ = try? await authService.deleteSession(sessionId: sessionId)
        }
        clearPersistentData()
        try? sessionManager.deleteSession()
        state = .loggedOut
    }

    // MARK: - Private

    private func clearPersistentData() {
        let context = ModelContext(modelContainer)
        try? context.delete(model: MovieEntity.self)
        try? context.delete(model: MoviePageMetadata.self)
        try? context.delete(model: RecentlyViewedMovie.self)
        try? context.save()
    }

    private func performWebAuth(url: URL) async throws -> URL {
        defer { activeWebAuthSession = nil }
        return try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(
                url: url,
                callbackURLScheme: "neugelbtest"
            ) { callbackURL, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let callbackURL {
                    continuation.resume(returning: callbackURL)
                } else {
                    continuation.resume(throwing: AuthError.invalidCallback)
                }
            }
            session.presentationContextProvider = anchor
            session.prefersEphemeralWebBrowserSession = false
            session.start()
            activeWebAuthSession = session
        }
    }

    private func extractRequestToken(from url: URL) throws -> String {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let items = components.queryItems else {
            throw AuthError.invalidCallback
        }
        let approved = items.first(where: { $0.name == "approved" })?.value
        guard approved == "true" else {
            throw AuthError.denied
        }
        guard let requestToken = items.first(where: { $0.name == "request_token" })?.value else {
            throw AuthError.invalidCallback
        }
        return requestToken
    }

    enum AuthError: LocalizedError {
        case invalidCallback
        case denied

        var errorDescription: String? {
            switch self {
            case .invalidCallback: return "Invalid authentication response."
            case .denied: return "Authentication was denied."
            }
        }
    }
}

// MARK: - WebAuthAnchor

private final class WebAuthAnchor: NSObject, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        MainActor.assumeIsolated {
            guard let scene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive })
                ?? UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first
            else {
                fatalError("No UIWindowScene found — cannot present authentication")
            }
            return scene.windows.first(where: { $0.isKeyWindow }) ?? UIWindow(windowScene: scene)
        }
    }
}
