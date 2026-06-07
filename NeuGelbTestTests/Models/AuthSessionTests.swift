import Testing
import Foundation
@testable import NeuGelbTest

@Suite("AuthSession Model Tests")
@MainActor
struct AuthSessionTests {

    @Test("Decodes all fields correctly from JSON")
    func testDecoding() throws {
        let json = """
        {
            "success": true,
            "session_id": "79191836ddaa0da3df76a5ffef6f07ad6ab0c641"
        }
        """.data(using: .utf8)!

        let session = try JSONDecoder().decode(AuthSession.self, from: json)

        #expect(session.success == true)
        #expect(session.sessionId == "79191836ddaa0da3df76a5ffef6f07ad6ab0c641")
    }

    @Test("Decodes success as false")
    func testDecodingSuccessFalse() throws {
        let json = """
        {
            "success": false,
            "session_id": ""
        }
        """.data(using: .utf8)!

        let session = try JSONDecoder().decode(AuthSession.self, from: json)

        #expect(session.success == false)
    }
}
