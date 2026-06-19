import Testing
import Foundation
import Networking
@testable import NeuGelbTest

@Suite("CreateSessionRequest Tests")
@MainActor
struct CreateSessionRequestTests {

    let baseURL = URL(string: "https://api.example.com")!
    let requestToken = "ff5c7eeb5a8870efe3cd7fc5c282cffd26800ecd"

    @Test("Request has correct endpoint")
    func testEndpoint() {
        let request = CreateSessionRequest(baseURL: baseURL, accessToken: "test-token", requestToken: requestToken)
        #expect(request.endpoint == "authentication/session/new")
    }

    @Test("Request method is POST")
    func testMethod() {
        let request = CreateSessionRequest(baseURL: baseURL, accessToken: "test-token", requestToken: requestToken)
        #expect(request.method == .post)
    }

    @Test("Request includes Accept header")
    func testAcceptHeader() {
        let request = CreateSessionRequest(baseURL: baseURL, accessToken: "test-token", requestToken: requestToken)
        #expect(request.headers["Accept"] == "application/json")
    }

    @Test("Request includes Content-Type header")
    func testContentTypeHeader() {
        let request = CreateSessionRequest(baseURL: baseURL, accessToken: "test-token", requestToken: requestToken)
        #expect(request.headers["Content-Type"] == "application/json")
    }

    @Test("Query parameters are nil")
    func testQueryParameters() {
        let request = CreateSessionRequest(baseURL: baseURL, accessToken: "test-token", requestToken: requestToken)
        #expect(request.queryParameters == nil)
    }

    @Test("Body is not nil")
    func testBodyIsNotNil() {
        let request = CreateSessionRequest(baseURL: baseURL, accessToken: "test-token", requestToken: requestToken)
        #expect(request.body != nil)
    }

    @Test("Body encodes the correct request token")
    func testBodyEncodesRequestToken() throws {
        let request = CreateSessionRequest(baseURL: baseURL, accessToken: "test-token", requestToken: requestToken)
        let body = try #require(request.body)
        let decoded = try JSONDecoder().decode([String: String].self, from: body)
        #expect(decoded["request_token"] == requestToken)
    }

    @Test("buildURLRequest constructs valid URL")
    func testBuildURLRequest() throws {
        let request = CreateSessionRequest(baseURL: baseURL, accessToken: "test-token", requestToken: requestToken)
        let urlRequest = try request.buildURLRequest()

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.url?.scheme == "https")
        #expect(urlRequest.url?.host == "api.example.com")
        #expect(urlRequest.url?.path == "/authentication/session/new")
    }
}
