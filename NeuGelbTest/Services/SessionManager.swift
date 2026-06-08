import Foundation

private let sessionKey = "com.neugelbtest.sessionId"

protocol SessionManagerProtocol {
    var sessionId: String? { get }
    func save(sessionId: String) throws
    func deleteSession() throws
}

final class SessionManager: SessionManagerProtocol {
    @Injected<KeychainServiceProtocol> var keychainService: any KeychainServiceProtocol

    var sessionId: String? {
        try? keychainService.load(for: sessionKey)
    }

    func save(sessionId: String) throws {
        try keychainService.save(sessionId, for: sessionKey)
    }

    func deleteSession() throws {
        try keychainService.delete(for: sessionKey)
    }
}
