//
//  MovieDetailRequest.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import Foundation

struct MovieDetailRequest: NetworkRequest, Sendable {
    typealias Response = MovieDetail
    
    let baseURL: URL
    let endpoint: String
    let method: HTTPMethod = .get
    let headers: [String: String] = ["Accept": "application/json"]
    let queryParameters: [String: String]? = nil
    
    init(baseURL: URL, movieId: Int) {
        self.baseURL = baseURL
        self.endpoint = "movie/\(movieId)"
    }
}
