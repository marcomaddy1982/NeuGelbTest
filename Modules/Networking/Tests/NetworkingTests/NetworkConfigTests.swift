//
//  NetworkConfigTests.swift
//  NetworkingTests
//

import Testing
import Foundation
@testable import Networking

@Suite("NetworkConfig Tests")
struct NetworkConfigTests {

    let config = NetworkConfig(
        baseURL: URL(string: "https://api.example.com")!,
        accessToken: "mock-token",
        imageBaseURL: URL(string: "https://image.example.com")!
    )

    @Test func successfulConfigLoad() {
        #expect(!config.baseURL.absoluteString.isEmpty)
        #expect(!config.accessToken.isEmpty)
    }

    @Test func baseURLIsValid() {
        #expect(config.baseURL.scheme != nil)
        #expect(!config.baseURL.absoluteString.isEmpty)
    }

    @Test func accessTokenIsNotEmpty() {
        #expect(!config.accessToken.isEmpty)
    }
}
