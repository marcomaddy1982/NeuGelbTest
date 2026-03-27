//
//  MockImageService.swift
//  NeuGelbTestTests
//
//  Created by Marco Maddalena on 23.03.26.
//

import SwiftUI
@testable import NeuGelbTest

final class MockImageService: ImageServiceProtocol {
    var shouldSucceed: Bool = true
    var mockImage: Image?
    
    var loadImageCallCount: Int = 0
    var lastPosterPathRequested: String?
    
    var buildImageURLCallCount: Int = 0
    var lastPathRequested: String?
    var lastSizeRequested: String?
    
    init() {}

    func simulateSuccess(with image: Image) {
        shouldSucceed = true
        mockImage = image
    }

    func simulateFailure() {
        shouldSucceed = false
        mockImage = nil
    }
    
    func loadImage(from posterPath: String) async -> Image? {
        loadImageCallCount += 1
        lastPosterPathRequested = posterPath
        
        guard shouldSucceed else {
            return nil
        }
        
        return mockImage
    }
    
    func buildImageURL(path: String, size: String) -> URL {
        buildImageURLCallCount += 1
        lastPathRequested = path
        lastSizeRequested = size
        
        // Return a mock URL for testing
        return URL(string: "https://image.tmdb.org/t/p/\(size)\(path)")!
    }
}
