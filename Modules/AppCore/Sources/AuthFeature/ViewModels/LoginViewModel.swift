import AppFeatures
import Foundation
import Models
import Observation

enum LoginState: Equatable {
    case idle
    case loading
    case success
    case error(String)
}

@Observable
@MainActor
final class LoginViewModel {
    var email: String = ""
    var password: String = ""
    var loginState: LoginState = .idle

    private let authService: any AuthServiceProtocol
    private let sessionManager: any SessionManagerProtocol

    init(authService: any AuthServiceProtocol, sessionManager: any SessionManagerProtocol) {
        self.authService = authService
        self.sessionManager = sessionManager
    }

    func login() async {
        loginState = .loading
        do {
            let response = try await authService.login(email: email, password: password)
            try sessionManager.save(accessToken: response.accessToken, refreshToken: response.refreshToken)
            loginState = .success
        } catch {
            loginState = .error(error.localizedDescription)
        }
    }
}
