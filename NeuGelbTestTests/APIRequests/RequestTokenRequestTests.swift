import Testing
import Foundation
import Networking
@testable import NeuGelbTest

@Suite("RequestTokenRequest Tests")
@MainActor
struct RequestTokenRequestTests {

    let baseURL = URL(string: "https://api.example.com")!

    @Test("Request has correct endpoint")
    func testEndpoint() {
        let request = RequestTokenRequest(baseURL: baseURL)
        #expect(request.endpoint == "authentication/token/new")
    }

    @Test("Request method is GET")
    func testMethod() {
        let request = RequestTokenRequest(baseURL: baseURL)
        #expect(request.method == .get)
    }

    @Test("Request includes Accept header")
    func testHeaders() {
        let request = RequestTokenRequest(baseURL: baseURL)
        #expect(request.headers["Accept"] == "application/json")
    }

    @Test("Query parameters are nil")
    func testQueryParameters() {
        let request = RequestTokenRequest(baseURL: baseURL)
        #expect(request.queryParameters == nil)
    }

    @Test("Body is nil")
    func testBody() {
        let request = RequestTokenRequest(baseURL: baseURL)
        #expect(request.body == nil)
    }

    @Test("buildURLRequest constructs valid URL")
    func testBuildURLRequest() throws {
        let request = RequestTokenRequest(baseURL: baseURL)
        let urlRequest = try request.buildURLRequest()

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.url?.scheme == "https")
        #expect(urlRequest.url?.host == "api.example.com")
        #expect(urlRequest.url?.path == "/authentication/token/new")
    }
}
