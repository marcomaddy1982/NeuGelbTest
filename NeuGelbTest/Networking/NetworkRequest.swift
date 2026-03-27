//
//  NetworkRequest.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 22.03.26.
//

import Foundation

protocol NetworkRequest: Sendable {
    associatedtype Response: Decodable & Sendable
    
    var baseURL: URL { get }
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String]? { get }
    
    func buildURLRequest() throws -> URLRequest
}

extension NetworkRequest {
    func buildURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(
            url: baseURL.appendingPathComponent(endpoint),
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkError.invalidURL
        }

        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            urlComponents.queryItems = queryParameters.map { 
                URLQueryItem(name: $0.key, value: $0.value) 
            }
        }
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
