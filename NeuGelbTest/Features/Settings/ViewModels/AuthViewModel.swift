import Foundation
import AuthenticationServices
import Observation
import UIKit

enum AuthState: Equatable {
    case loggedOut
    case loading
    case loggedIn(sessionId: String)
    case error(String)
}

@Observable
@MainActor
final class AuthViewModel {
    var state: AuthState

    private let authService: any AuthServiceProtocol
    private let sessionManager: any SessionManagerProtocol
    private let anchor = WebAuthAnchor()
    private var activeWebAuthSession: ASWebAuthenticationSession?

    init(authService: any AuthServiceProtocol, sessionManager: any SessionManagerProtocol) {
        self.authService = authService
        self.sessionManager = sessionManager
        self.state = sessionManager.sessionId.map { .loggedIn(sessionId: $0) } ?? .loggedOut
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
            try sessionManager.save(sessionId: session.sessionId)
            state = .loggedIn(sessionId: session.sessionId)
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
        let currentSessionId = sessionManager.sessionId
        state = .loading
        if let sessionId = currentSessionId {
            _ = try? await authService.deleteSession(sessionId: sessionId)
        }
        try? sessionManager.deleteSession()
        state = .loggedOut
    }

    // MARK: - Private

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
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first(where: { $0.activationState == .foregroundActive })?
                .windows.first(where: { $0.isKeyWindow })
                ?? UIWindow()
        }
    }
}
