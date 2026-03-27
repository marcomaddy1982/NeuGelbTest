//
//  DISetup.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 23.03.26.
//

import Foundation

func setupDependencies() {
    do {
        let config = try NetworkConfig()
        DIContainer.shared.register(config)
        
        let networkClient = NetworkClient(config: config)
        DIContainer.shared.register(networkClient)
        
        let movieService = MovieService()
        DIContainer.shared.register(movieService as MovieServiceProtocol)
        
        let searchService = SearchService()
        DIContainer.shared.register(searchService as SearchServiceProtocol)
        
        let imageService = ImageService(networkClient: networkClient, imageBaseURL: config.imageBaseURL, cache: ImageCache.shared)
        DIContainer.shared.register(imageService as ImageServiceProtocol)
    } catch {
        print("❌ Failed to setup dependencies: \(error)")
    }
}
