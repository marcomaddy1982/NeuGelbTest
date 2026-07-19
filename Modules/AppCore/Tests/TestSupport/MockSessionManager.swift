import AppFeatures
import Foundation

public final class MockSessionManager: SessionManagerProtocol {
    public var accessToken: String?
    public var refreshToken: String?

    public var saveCallCount: Int = 0
    public var deleteSessionCallCount: Int = 0
    public var lastSavedAccessToken: String?
    public var lastSavedRefreshToken: String?
    public var shouldThrow: Bool = false

    public init() {}

    public func save(accessToken: String, refreshToken: String) throws {
        saveCallCount += 1
        lastSavedAccessToken = accessToken
        lastSavedRefreshToken = refreshToken
        if shouldThrow { throw MockSessionError.generic }
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    public func deleteSession() throws {
        deleteSessionCallCount += 1
        if shouldThrow { throw MockSessionError.generic }
        accessToken = nil
        refreshToken = nil
    }
}

private enum MockSessionError: Error {
    case generic
}
