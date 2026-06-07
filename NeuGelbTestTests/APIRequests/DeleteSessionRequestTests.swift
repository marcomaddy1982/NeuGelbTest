import Testing
import Foundation
import Networking
@testable import NeuGelbTest

@Suite("DeleteSessionRequest Tests")
@MainActor
struct DeleteSessionRequestTests {

    let baseURL = URL(string: "https://api.example.com")!
    let sessionId = "79191836ddaa0da3df76a5ffef6f07ad6ab0c641"

    @Test("Request has correct endpoint")
    func testEndpoint() {
        let request = DeleteSessionRequest(baseURL: baseURL, sessionId: sessionId)
        #expect(request.endpoint == "authentication/session")
    }

    @Test("Request method is DELETE")
    func testMethod() {
        let request = DeleteSessionRequest(baseURL: baseURL, sessionId: sessionId)
        #expect(request.method == .delete)
    }

    @Test("Request includes Accept header")
    func testAcceptHeader() {
        let request = DeleteSessionRequest(baseURL: baseURL, sessionId: sessionId)
        #expect(request.headers["Accept"] == "application/json")
    }

    @Test("Request includes Content-Type header")
    func testContentTypeHeader() {
        let request = DeleteSessionRequest(baseURL: baseURL, sessionId: sessionId)
        #expect(request.headers["Content-Type"] == "application/json")
    }

    @Test("Query parameters are nil")
    func testQueryParameters() {
        let request = DeleteSessionRequest(baseURL: baseURL, sessionId: sessionId)
        #expect(request.queryParameters == nil)
    }

    @Test("Body is not nil")
    func testBodyIsNotNil() {
        let request = DeleteSessionRequest(baseURL: baseURL, sessionId: sessionId)
        #expect(request.body != nil)
    }

    @Test("Body encodes the correct session ID")
    func testBodyEncodesSessionId() throws {
        let request = DeleteSessionRequest(baseURL: baseURL, sessionId: sessionId)
        let body = try #require(request.body)
        let decoded = try JSONDecoder().decode([String: String].self, from: body)
        #expect(decoded["session_id"] == sessionId)
    }

    @Test("buildURLRequest constructs valid URL")
    func testBuildURLRequest() throws {
        let request = DeleteSessionRequest(baseURL: baseURL, sessionId: sessionId)
        let urlRequest = try request.buildURLRequest()

        #expect(urlRequest.httpMethod == "DELETE")
        #expect(urlRequest.url?.scheme == "https")
        #expect(urlRequest.url?.host == "api.example.com")
        #expect(urlRequest.url?.path == "/authentication/session")
    }
}
