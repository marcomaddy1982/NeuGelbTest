import Foundation
import Observation

private let sessionKey = "com.neugelbtest.sessionId"

protocol SessionManagerProtocol {
    var sessionId: String? { get }
    func save(sessionId: String) throws
    func deleteSession() throws
}

@Observable
final class SessionManager: SessionManagerProtocol {
    @ObservationIgnored @Injected<KeychainServiceProtocol> private var keychainService: any KeychainServiceProtocol

    private(set) var sessionId: String?

    init() {
        sessionId = try? keychainService.load(for: sessionKey)
    }

    func save(sessionId: String) throws {
        try keychainService.save(sessionId, for: sessionKey)
        self.sessionId = sessionId
    }

    func deleteSession() throws {
        try keychainService.delete(for: sessionKey)
        self.sessionId = nil
    }
}
