import Foundation
import Models
import Networking

public protocol AuthServiceProtocol {
    func register(email: String, password: String, name: String, phoneNumber: String) async throws -> AuthTokenResponse
    func login(email: String, password: String) async throws -> AuthTokenResponse
    func logout(refreshToken: String) async throws
}

public class AuthService: AuthServiceProtocol {
    @Injected<NetworkClientProtocol> var networkClient: any NetworkClientProtocol
    @Injected<KinoAPIConfig> var kinoAPIConfig: KinoAPIConfig

    public init() {}

    public func register(email: String, password: String, name: String, phoneNumber: String) async throws -> AuthTokenResponse {
        let request = RegisterRequest(baseURL: kinoAPIConfig.baseURL, email: email, password: password, name: name, phoneNumber: phoneNumber)
        return try await networkClient.fetch(request)
    }

    public func login(email: String, password: String) async throws -> AuthTokenResponse {
        let request = LoginRequest(baseURL: kinoAPIConfig.baseURL, email: email, password: password)
        return try await networkClient.fetch(request)
    }

    public func logout(refreshToken: String) async throws {
        let request = LogoutRequest(baseURL: kinoAPIConfig.baseURL, refreshToken: refreshToken)
        _ = try await networkClient.fetch(request)
    }
}
