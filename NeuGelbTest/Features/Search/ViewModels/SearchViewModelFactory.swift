//
//  SearchViewModelFactory.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 25.03.26.
//

import Foundation

@MainActor
final class SearchViewModelFactory {
    @Injected<SearchServiceProtocol> var searchService
    @Injected<ImageServiceProtocol> var imageService
    
    static func makeSearchViewModel() -> SearchViewModel {
        let factory = SearchViewModelFactory()
        return SearchViewModel(
            searchService: factory.searchService,
            imageService: factory.imageService
        )
    }
}
