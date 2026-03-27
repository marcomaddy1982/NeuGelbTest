//
//  NetworkConfigTests.swift
//  NeuGelbTestTests
//
//  Created by Marco Maddalena on 22.03.26.
//

import Testing
import Foundation
@testable import NeuGelbTest

@Suite("NetworkConfigTests Tests")
@MainActor
struct NetworkConfigTests {
    @Test func successfulConfigLoad() throws {
        let config = MockNetworkConfig()
        #expect(!config.baseURL.absoluteString.isEmpty)
        #expect(!config.accessToken.isEmpty)
    }

    @Test func baseURLIsValid() throws {
        let config = MockNetworkConfig()
        #expect(config.baseURL.scheme != nil)
        #expect(!config.baseURL.absoluteString.isEmpty)
    }

    @Test func accessTokenIsNotEmpty() throws {
        let config = MockNetworkConfig()
        #expect(!config.accessToken.isEmpty)
    }
}
