//
//  MockNetworkConfig.swift
//  NeuGelbTestTests
//
//  Created by Marco Maddalena on 22.03.26.
//

import Foundation
@testable import NeuGelbTest

final class MockNetworkConfig: Sendable {
    let baseURL: URL
    let accessToken: String

    init(baseURL: URL = URL(string: "https://api.example.com")!, accessToken: String = "mock-token") {
        self.baseURL = baseURL
        self.accessToken = accessToken
    }
    
    static func testAPI() -> MockNetworkConfig {
        MockNetworkConfig()
    }
}
