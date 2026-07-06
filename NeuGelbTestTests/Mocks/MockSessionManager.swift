import Foundation
@testable import NeuGelbTest

final class MockSessionManager: SessionManagerProtocol {
    var accessToken: String?
    var refreshToken: String?

    var saveCallCount: Int = 0
    var deleteSessionCallCount: Int = 0
    var lastSavedAccessToken: String?
    var lastSavedRefreshToken: String?
    var shouldThrow: Bool = false

    func save(accessToken: String, refreshToken: String) throws {
        saveCallCount += 1
        lastSavedAccessToken = accessToken
        lastSavedRefreshToken = refreshToken
        if shouldThrow { throw MockSessionError.generic }
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    func deleteSession() throws {
        deleteSessionCallCount += 1
        if shouldThrow { throw MockSessionError.generic }
        accessToken = nil
        refreshToken = nil
    }
}

private enum MockSessionError: Error {
    case generic
}
