//
//  MockRequest.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import Foundation
@testable import NeuGelbTest

struct MockRequest: NetworkRequest {
    typealias Response = MockResponse

    var baseURL: URL = URL(string: "https://api.example.com")!
    var endpoint: String = "/test"
    var method: HTTPMethod = .get
    var headers: [String: String] = ["Accept": "application/json"]
    var queryParameters: [String: String]? = nil
}

struct MockResponse: Decodable, Sendable {
    let id: Int
    let name: String
}
