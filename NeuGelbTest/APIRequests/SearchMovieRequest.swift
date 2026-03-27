//
//  SearchMovieRequest.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import Foundation

struct SearchMovieRequest: NetworkRequest, Sendable {
    typealias Response = MovieListResponse
    
    let baseURL: URL
    let query: String
    let page: Int
    
    let endpoint: String = "search/movie"
    let method: HTTPMethod = .get
    let headers: [String: String] = ["Accept": "application/json"]
    let queryParameters: [String: String]?
    
    init(baseURL: URL, query: String, page: Int = 1) {
        self.baseURL = baseURL
        self.query = query
        self.page = page
        self.queryParameters = [
            "query": query,
            "page": String(page),
            "include_adult": "false",
            "language": "en-US"
        ]
    }
}
