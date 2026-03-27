//
//  ImageCache.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 23.03.26.
//

import SwiftUI

protocol ImageCaching {
    func getCachedImage(_ url: URL) async -> Image?
    func setCachedImage(_ image: Image, for url: URL) async
    func removeAll() async
}

actor ImageCache: ImageCaching {
    static let shared = ImageCache()
    
    private var cache: [URL: Image] = [:]
    
    func getCachedImage(_ url: URL) -> Image? {
        cache[url]
    }
    
    func setCachedImage(_ image: Image, for url: URL) {
        cache[url] = image
    }
    
    func removeAll() {
        cache.removeAll()
    }
}
