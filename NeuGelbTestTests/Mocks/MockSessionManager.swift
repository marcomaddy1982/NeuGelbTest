import Foundation
@testable import NeuGelbTest

final class MockSessionManager: SessionManagerProtocol {
    var sessionId: String?

    var saveCallCount: Int = 0
    var deleteSessionCallCount: Int = 0
    var lastSavedSessionId: String?
    var shouldThrow: Bool = false

    func save(sessionId: String) throws {
        saveCallCount += 1
        lastSavedSessionId = sessionId
        if shouldThrow { throw MockSessionError.generic }
        self.sessionId = sessionId
    }

    func deleteSession() throws {
        deleteSessionCallCount += 1
        if shouldThrow { throw MockSessionError.generic }
        sessionId = nil
    }
}

private enum MockSessionError: Error {
    case generic
}
