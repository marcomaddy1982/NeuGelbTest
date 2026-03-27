//
//  ImageRequest.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 23.03.26.
//

import Foundation

struct ImageRequest: NetworkRequest, Sendable {
    typealias Response = Data
    
    let baseURL: URL
    let endpoint: String
    let method: HTTPMethod = .get
    let headers: [String: String] = [:]
    let queryParameters: [String: String]? = nil
    
    init(baseURL: URL, endpoint: String) {
        self.baseURL = baseURL
        self.endpoint = endpoint
    }
}
