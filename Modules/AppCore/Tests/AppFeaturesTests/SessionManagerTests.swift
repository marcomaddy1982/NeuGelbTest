import AppFeatures
import Foundation
import Testing
import TestSupport


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

    @Test("accessToken is nil when keychain is empty")
    func testAccessTokenIsNilWhenKeychainIsEmpty() {
        let sut = makeSUT()

        #expect(sut.accessToken == nil)
        #expect(sut.refreshToken == nil)
    }

    @Test("save then accessToken and refreshToken return saved values")
    func testSaveThenTokensReturnValues() throws {
        let sut = makeSUT()

        try sut.save(accessToken: "access123", refreshToken: "refresh123")

        #expect(sut.accessToken == "access123")
        #expect(sut.refreshToken == "refresh123")
    }

    @Test("deleteSession then tokens are nil")
    func testDeleteSessionThenTokensAreNil() throws {
        let sut = makeSUT()

        try sut.save(accessToken: "access123", refreshToken: "refresh123")
        try sut.deleteSession()

        #expect(sut.accessToken == nil)
        #expect(sut.refreshToken == nil)
    }

    @Test("save propagates KeychainError when keychain throws")
    func testSavePropagatesKeychainError() {
        let sut = makeSUT(shouldThrow: true)

        #expect(throws: (any Error).self) {
            try sut.save(accessToken: "access123", refreshToken: "refresh123")
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
