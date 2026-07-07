import Foundation
import Networking

protocol AuthServiceProtocol {
    func register(email: String, password: String, name: String, phoneNumber: String) async throws -> AuthTokenResponse
    func login(email: String, password: String) async throws -> AuthTokenResponse
    func logout(refreshToken: String) async throws
}

class AuthService: AuthServiceProtocol {
    @Injected<NetworkClientProtocol> var networkClient: any NetworkClientProtocol
    @Injected<KinoAPIConfig> var kinoAPIConfig: KinoAPIConfig

    func register(email: String, password: String, name: String, phoneNumber: String) async throws -> AuthTokenResponse {
        let request = RegisterRequest(baseURL: kinoAPIConfig.baseURL, email: email, password: password, name: name, phoneNumber: phoneNumber)
        return try await networkClient.fetch(request)
    }

    func login(email: String, password: String) async throws -> AuthTokenResponse {
        let request = LoginRequest(baseURL: kinoAPIConfig.baseURL, email: email, password: password)
        return try await networkClient.fetch(request)
    }

    func logout(refreshToken: String) async throws {
        let request = LogoutRequest(baseURL: kinoAPIConfig.baseURL, refreshToken: refreshToken)
        _ = try await networkClient.fetch(request)
    }
}
