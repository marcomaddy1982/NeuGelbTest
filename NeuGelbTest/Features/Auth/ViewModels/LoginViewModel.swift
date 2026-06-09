import Foundation
import AuthenticationServices
import Observation
import UIKit

enum LoginState: Equatable {
    case idle
    case loading
    case error(String)
}

@Observable
@MainActor
final class LoginViewModel {
    var loginState: LoginState = .idle

    private let authService: any AuthServiceProtocol
    private let sessionManager: any SessionManagerProtocol
    private let anchor = WebAuthAnchor()
    private var activeWebAuthSession: ASWebAuthenticationSession?

    init(authService: any AuthServiceProtocol, sessionManager: any SessionManagerProtocol) {
        self.authService = authService
        self.sessionManager = sessionManager
    }

    func login() async {
        loginState = .loading
        do {
            let token = try await authService.requestToken()
            let url = authService.authorizationURL(for: token.requestToken)
            let callbackURL = try await performWebAuth(url: url)
            let approvedToken = try extractRequestToken(from: callbackURL)
            let session = try await authService.createSession(requestToken: approvedToken)
            try sessionManager.save(sessionId: session.sessionId)
            loginState = .idle
        } catch {
            let nsError = error as NSError
            if nsError.domain == ASWebAuthenticationSessionErrorDomain,
               nsError.code == ASWebAuthenticationSessionError.canceledLogin.rawValue {
                loginState = .idle
            } else {
                loginState = .error(error.localizedDescription)
            }
        }
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
                    continuation.resume(throwing: LoginError.invalidCallback)
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
            throw LoginError.invalidCallback
        }
        let approved = items.first(where: { $0.name == "approved" })?.value
        guard approved == "true" else {
            throw LoginError.denied
        }
        guard let requestToken = items.first(where: { $0.name == "request_token" })?.value else {
            throw LoginError.invalidCallback
        }
        return requestToken
    }

    enum LoginError: LocalizedError {
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
