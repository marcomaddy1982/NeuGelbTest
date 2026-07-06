import Foundation
import Observation

private let accessTokenKey = "com.neugelbtest.accessToken"
private let refreshTokenKey = "com.neugelbtest.refreshToken"

protocol SessionManagerProtocol {
    var accessToken: String? { get }
    var refreshToken: String? { get }
    func save(accessToken: String, refreshToken: String) throws
    func deleteSession() throws
}

@Observable
final class SessionManager: SessionManagerProtocol {
    @ObservationIgnored @Injected<KeychainServiceProtocol> private var keychainService: any KeychainServiceProtocol

    private(set) var accessToken: String?
    private(set) var refreshToken: String?

    init() {
        accessToken = try? keychainService.load(for: accessTokenKey)
        refreshToken = try? keychainService.load(for: refreshTokenKey)
    }

    func save(accessToken: String, refreshToken: String) throws {
        try keychainService.save(accessToken, for: accessTokenKey)
        try keychainService.save(refreshToken, for: refreshTokenKey)
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    func deleteSession() throws {
        try keychainService.delete(for: accessTokenKey)
        try keychainService.delete(for: refreshTokenKey)
        self.accessToken = nil
        self.refreshToken = nil
    }
}
