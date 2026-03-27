//
//  MockImageCache.swift
//  NeuGelbTestTests
//
//  Created by Marco Maddalena on 23.03.26.
//

import SwiftUI
@testable import NeuGelbTest

actor MockImageCache: ImageCaching {
    private var cache: [URL: Image] = [:]
    
    nonisolated(unsafe) var getCachedImageCallCount: Int = 0
    nonisolated(unsafe) var setCachedImageCallCount: Int = 0
    nonisolated(unsafe) var removeAllCallCount: Int = 0
    
    init() {}
    
    func getCachedImage(_ url: URL) -> Image? {
        getCachedImageCallCount += 1
        return cache[url]
    }
    
    func setCachedImage(_ image: Image, for url: URL) {
        setCachedImageCallCount += 1
        cache[url] = image
    }
    
    func removeAll() {
        removeAllCallCount += 1
        cache.removeAll()
    }
    
    func prePopulate(with images: [URL: Image]) {
        for (url, image) in images {
            cache[url] = image
        }
    }
}
