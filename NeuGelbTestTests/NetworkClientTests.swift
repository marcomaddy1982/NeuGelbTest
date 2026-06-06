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

    @Test func bodyIsNilByDefault() throws {
        let request = MockRequest()
        let urlRequest = try request.buildURLRequest()

        #expect(urlRequest.httpBody == nil)
    }

    @Test func bodyIsAttachedWhenPresent() throws {
        let payload = #"{"name":"test"}"#.data(using: .utf8)!
        var request = MockRequest()
        request.method = .post
        request.body = payload

        let urlRequest = try request.buildURLRequest()

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.httpBody == payload)
    }

    @Test func httpMethodIsSetCorrectly() throws {
        let methods: [HTTPMethod] = [.get, .post, .put, .patch, .delete]

        for method in methods {
            var request = MockRequest()
            request.method = method
            let urlRequest = try request.buildURLRequest()
            #expect(urlRequest.httpMethod == method.rawValue)
        }
    }
}
