//
//  MockRequest.swift
//  NetworkingTests
//

import Foundation
import Networking

struct MockRequest: NetworkRequest {
    typealias Response = MockResponse

    var baseURL: URL = URL(string: "https://api.example.com")!
    var endpoint: String = "/test"
    var method: HTTPMethod = .get
    var headers: [String: String] = ["Accept": "application/json"]
    var queryParameters: [String: String]? = nil
    var body: Data? = nil
}

struct MockResponse: Decodable, Sendable {
    let id: Int
    let name: String
}
