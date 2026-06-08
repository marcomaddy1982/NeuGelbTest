import Testing
import Foundation
@testable import NeuGelbTest

@Suite("SessionManager Tests")
@MainActor
struct SessionManagerTests {

    private func makeSUT(shouldThrow: Bool = false) -> SessionManager {
        let mock = MockKeychainService()
        mock.shouldThrow = shouldThrow
        DIContainer.shared.reset()
        DIContainer.shared.register(mock as KeychainServiceProtocol)
        return SessionManager()
    }

    @Test("sessionId is nil when keychain is empty")
    func testSessionIdIsNilWhenKeychainIsEmpty() {
        let sut = makeSUT()

        #expect(sut.sessionId == nil)
    }

    @Test("save then sessionId returns the saved value")
    func testSaveThenSessionIdReturnsValue() throws {
        let sut = makeSUT()

        try sut.save(sessionId: "abc123")

        #expect(sut.sessionId == "abc123")
    }

    @Test("deleteSession then sessionId is nil")
    func testDeleteSessionThenSessionIdIsNil() throws {
        let sut = makeSUT()

        try sut.save(sessionId: "abc123")
        try sut.deleteSession()

        #expect(sut.sessionId == nil)
    }

    @Test("save propagates KeychainError when keychain throws")
    func testSavePropagatesKeychainError() {
        let sut = makeSUT(shouldThrow: true)

        #expect(throws: (any Error).self) {
            try sut.save(sessionId: "abc123")
        }
    }

    @Test("deleteSession propagates KeychainError when keychain throws")
    func testDeleteSessionPropagatesKeychainError() {
        let sut = makeSUT(shouldThrow: true)

        #expect(throws: (any Error).self) {
            try sut.deleteSession()
        }
    }
}
