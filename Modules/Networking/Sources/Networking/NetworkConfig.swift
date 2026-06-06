//
//  NetworkConfig.swift
//  Networking
//

import Foundation

public final class NetworkConfig: Sendable {
    public let baseURL: URL
    public let accessToken: String
    public let imageBaseURL: URL

    public init(baseURL: URL, accessToken: String, imageBaseURL: URL) {
        self.baseURL = baseURL
        self.accessToken = accessToken
        self.imageBaseURL = imageBaseURL
    }

    public init() throws {
        guard let plistDict = Bundle.main.infoDictionary else {
            let errorMessage = "Failed to load Config.plist from bundle"
            print("❌ \(errorMessage)")
            throw NetworkError.configError(errorMessage)
        }

        guard let baseURLString = plistDict["baseURL"] as? String,
              let url = URL(string: baseURLString) else {
            let errorMessage = "Invalid or missing baseURL in Config.plist"
            print("❌ \(errorMessage)")
            throw NetworkError.configError(errorMessage)
        }

        guard let accessToken = plistDict["accessToken"] as? String,
              !accessToken.isEmpty else {
            let errorMessage = "Invalid or missing accessToken in Config.plist"
            print("❌ \(errorMessage)")
            throw NetworkError.configError(errorMessage)
        }

        guard let imageBaseURLString = plistDict["imageBaseURL"] as? String,
              let imageURL = URL(string: imageBaseURLString) else {
            let errorMessage = "Invalid or missing imageBaseURL in Config.plist"
            print("❌ \(errorMessage)")
            throw NetworkError.configError(errorMessage)
        }

        self.baseURL = url
        self.accessToken = accessToken
        self.imageBaseURL = imageURL
    }
}
