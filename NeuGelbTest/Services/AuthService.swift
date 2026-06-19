import Foundation
import Networking

private let authorizationBaseURL = "https://www.themoviedb.org/authenticate/"

protocol AuthServiceProtocol {
    func requestToken() async throws -> RequestToken
    func createSession(requestToken: String) async throws -> AuthSession
    func deleteSession(sessionId: String) async throws -> DeleteSessionResponse
    func authorizationURL(for requestToken: String) -> URL
}

class AuthService: AuthServiceProtocol {
    @Injected<NetworkClient> var networkClient: NetworkClient
    @Injected<NetworkConfig> var networkConfig: NetworkConfig

    func requestToken() async throws -> RequestToken {
        let request = RequestTokenRequest(baseURL: networkConfig.baseURL, accessToken: networkConfig.accessToken)
        return try await networkClient.fetch(request)
    }

    func createSession(requestToken: String) async throws -> AuthSession {
        let request = CreateSessionRequest(baseURL: networkConfig.baseURL, accessToken: networkConfig.accessToken, requestToken: requestToken)
        return try await networkClient.fetch(request)
    }

    func deleteSession(sessionId: String) async throws -> DeleteSessionResponse {
        let request = DeleteSessionRequest(baseURL: networkConfig.baseURL, accessToken: networkConfig.accessToken, sessionId: sessionId)
        return try await networkClient.fetch(request)
    }

    func authorizationURL(for requestToken: String) -> URL {
        URL(string: "\(authorizationBaseURL)\(requestToken)?redirect_to=neugelbtest://auth")!
    }
}
