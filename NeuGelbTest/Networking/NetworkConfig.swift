//
//  NetworkConfig.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 22.03.26.
//

import Foundation

final class NetworkConfig: Sendable {
    let baseURL: URL
    let accessToken: String
    let imageBaseURL: URL
    
    init() throws {
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
