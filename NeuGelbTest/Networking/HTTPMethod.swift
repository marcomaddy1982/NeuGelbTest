//
//  HTTPMethod.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 22.03.26.
//

enum HTTPMethod: String, Sendable {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}
