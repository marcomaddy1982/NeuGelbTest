import Testing
import Foundation
@testable import NeuGelbTest

@Suite("KeychainService Tests")
@MainActor
struct KeychainServiceTests {

    let sut = KeychainService()
    let testKey = "com.neugelbtest.test"

    private func cleanUp() {
        try? sut.delete(for: testKey)
    }

    @Test("save then load returns the saved value")
    func testSaveAndLoad() throws {
        cleanUp()
        defer { cleanUp() }

        try sut.save("testValue", for: testKey)
        let loaded = try sut.load(for: testKey)

        #expect(loaded == "testValue")
    }

    @Test("load on non-existent key returns nil")
    func testLoadNonExistentKeyReturnsNil() throws {
        cleanUp()
        defer { cleanUp() }

        let loaded = try sut.load(for: testKey)

        #expect(loaded == nil)
    }

    @Test("save twice overwrites the first value")
    func testSaveOverwrites() throws {
        cleanUp()
        defer { cleanUp() }

        try sut.save("firstValue", for: testKey)
        try sut.save("secondValue", for: testKey)
        let loaded = try sut.load(for: testKey)

        #expect(loaded == "secondValue")
    }

    @Test("delete then load returns nil")
    func testDeleteThenLoadReturnsNil() throws {
        cleanUp()
        defer { cleanUp() }

        try sut.save("testValue", for: testKey)
        try sut.delete(for: testKey)
        let loaded = try sut.load(for: testKey)

        #expect(loaded == nil)
    }

    @Test("delete on non-existent key does not throw")
    func testDeleteNonExistentKeyDoesNotThrow() throws {
        cleanUp()
        defer { cleanUp() }

        try sut.delete(for: testKey)
    }
}
