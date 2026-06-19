//
//  MovieDetailRequest.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import Foundation
import Networking

struct MovieDetailRequest: NetworkRequest, Sendable {
    typealias Response = MovieDetail
    
    let baseURL: URL
    let endpoint: String
    let method: HTTPMethod = .get
    let headers: [String: String]
    let queryParameters: [String: String]? = nil

    init(baseURL: URL, accessToken: String, movieId: Int) {
        self.baseURL = baseURL
        self.headers = ["Accept": "application/json", "Authorization": "Bearer \(accessToken)"]
        self.endpoint = "movie/\(movieId)"
    }
}
