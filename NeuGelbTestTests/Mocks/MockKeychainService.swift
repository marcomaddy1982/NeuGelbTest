import Foundation
@testable import NeuGelbTest

final class MockKeychainService: KeychainServiceProtocol, Sendable {
    nonisolated(unsafe) var storage: [String: String] = [:]
    nonisolated(unsafe) var shouldThrow: Bool = false

    func save(_ value: String, for key: String) throws {
        if shouldThrow { throw KeychainError.saveFailed(-1) }
        storage[key] = value
    }

    func load(for key: String) throws -> String? {
        if shouldThrow { throw KeychainError.loadFailed(-1) }
        return storage[key]
    }

    func delete(for key: String) throws {
        if shouldThrow { throw KeychainError.deleteFailed(-1) }
        storage.removeValue(forKey: key)
    }
}
