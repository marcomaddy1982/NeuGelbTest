import AppFeatures
import Foundation

public final class MockKeychainService: KeychainServiceProtocol, Sendable {
    public nonisolated(unsafe) var storage: [String: String] = [:]
    public nonisolated(unsafe) var shouldThrow: Bool = false

    public init() {}

    public func save(_ value: String, for key: String) throws {
        if shouldThrow { throw KeychainError.saveFailed(-1) }
        storage[key] = value
    }

    public func load(for key: String) throws -> String? {
        if shouldThrow { throw KeychainError.loadFailed(-1) }
        return storage[key]
    }

    public func delete(for key: String) throws {
        if shouldThrow { throw KeychainError.deleteFailed(-1) }
        storage.removeValue(forKey: key)
    }
}
