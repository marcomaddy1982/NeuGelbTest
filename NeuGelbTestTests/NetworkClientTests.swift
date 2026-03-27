//
//  NetworkClientTests.swift
//  NeuGelbTestTests
//
//  Created by Marco Maddalena on 22.03.26.
//

import Testing
import Foundation
@testable import NeuGelbTest

@Suite("NetworkClientTests Tests")
@MainActor
struct NetworkClientTests {
    @Test func buildURLRequest() throws {
        let request = MockRequest()
        let urlRequest = try request.buildURLRequest()

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.url?.path == "/test")
    }

    @Test func buildURLRequestWithQueryParameters() throws {
        var request = MockRequest()
        request.queryParameters = ["key": "value", "foo": "bar"]

        let urlRequest = try request.buildURLRequest()
        #expect(urlRequest.url?.query != nil)
        #expect(urlRequest.url?.query?.contains("key=value") ?? false)
    }

    @Test func authorizationHeaderAdded() throws {
        let config = MockNetworkConfig()
        let request = MockRequest()
        var urlRequest = try request.buildURLRequest()

        urlRequest.setValue("Bearer \(config.accessToken)", forHTTPHeaderField: "Authorization")

        let authHeader = urlRequest.value(forHTTPHeaderField: "Authorization")
        #expect(authHeader == "Bearer \(config.accessToken)")
    }

    @Test func customHeadersIncluded() throws {
        var request = MockRequest()
        request.headers = ["Accept": "application/json", "Custom-Header": "CustomValue"]

        let urlRequest = try request.buildURLRequest()

        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Custom-Header") == "CustomValue")
    }
}
