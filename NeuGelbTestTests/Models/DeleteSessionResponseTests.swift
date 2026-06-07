import Testing
import Foundation
@testable import NeuGelbTest

@Suite("DeleteSessionResponse Model Tests")
@MainActor
struct DeleteSessionResponseTests {

    @Test("Decodes success as true")
    func testDecodingSuccessTrue() throws {
        let json = """
        {
            "success": true
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(DeleteSessionResponse.self, from: json)

        #expect(response.success == true)
    }

    @Test("Decodes success as false")
    func testDecodingSuccessFalse() throws {
        let json = """
        {
            "success": false
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(DeleteSessionResponse.self, from: json)

        #expect(response.success == false)
    }
}
