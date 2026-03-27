//
//  MovieListRequest.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 22.03.26.
//

import Foundation

struct MovieListRequest: NetworkRequest, Sendable {
    typealias Response = MovieListResponse
    
    let baseURL: URL
    let endpoint: String = "discover/movie"
    let method: HTTPMethod = .get
    let headers: [String: String] = ["Accept": "application/json"]
    let queryParameters: [String: String]?
    
    init(baseURL: URL, page: Int = 1) {
        self.baseURL = baseURL
        self.queryParameters = [
            "page": String(page),
            "include_adult": "false",
            "language": "en-US",
            "sort_by": "primary_release_date.desc",
            "primary_release_date.lte": Date.todayAsAPIFormat()
        ]
    }
}
