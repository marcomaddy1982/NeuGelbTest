import Testing
import Foundation
@testable import NeuGelbTest

@Suite("RequestToken Model Tests")
@MainActor
struct RequestTokenTests {

    @Test("Decodes all fields correctly from JSON")
    func testDecoding() throws {
        let json = """
        {
            "success": true,
            "expires_at": "2024-01-01 12:00:00 UTC",
            "request_token": "abc123def456"
        }
        """.data(using: .utf8)!

        let token = try JSONDecoder().decode(RequestToken.self, from: json)

        #expect(token.success == true)
        #expect(token.expiresAt == "2024-01-01 12:00:00 UTC")
        #expect(token.requestToken == "abc123def456")
    }

    @Test("Decodes success as false")
    func testDecodingSuccessFalse() throws {
        let json = """
        {
            "success": false,
            "expires_at": "2024-01-01 12:00:00 UTC",
            "request_token": "abc123def456"
        }
        """.data(using: .utf8)!

        let token = try JSONDecoder().decode(RequestToken.self, from: json)

        #expect(token.success == false)
    }
}
