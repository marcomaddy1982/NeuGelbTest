import Foundation
import Networking
@testable import NeuGelbTest

final class MockListsService: ListsServiceProtocol {
    var shouldSucceed: Bool = true
    var error: Error?

    var fetchListsCallCount: Int = 0
    var createListCallCount: Int = 0
    var deleteListCallCount: Int = 0
    var addItemCallCount: Int = 0
    var removeItemCallCount: Int = 0
    var fetchItemsCallCount: Int = 0
    var checkFavouriteCallCount: Int = 0
    var toggleFavouriteCallCount: Int = 0

    var lastCreatedListName: String?
    var lastDeletedListId: Int?
    var lastAddedItem: (listId: Int, tmdbMovieId: Int)?
    var lastRemovedItem: (listId: Int, tmdbMovieId: Int)?
    var lastCheckedTmdbMovieId: Int?
    var lastToggledTmdbMovieId: Int?

    var mockIsFavourite: Bool = false
    var mockToggleResult: Bool = true

    var mockLists: [MovieList] = []
    var mockList: MovieList?
    var mockListItem: AddListItemResponse?
    var mockListItems: [Movie] = []

    func fetchLists() async throws -> [MovieList] {
        fetchListsCallCount += 1
        if let error { throw error }
        return mockLists
    }

    func createList(name: String) async throws -> MovieList {
        createListCallCount += 1
        lastCreatedListName = name
        if let error { throw error }
        guard let mockList else { throw NetworkError.noData }
        return mockList
    }

    func deleteList(id: Int) async throws {
        deleteListCallCount += 1
        lastDeletedListId = id
        if let error { throw error }
    }

    func addItem(listId: Int, tmdbMovieId: Int) async throws -> AddListItemResponse {
        addItemCallCount += 1
        lastAddedItem = (listId, tmdbMovieId)
        if let error { throw error }
        guard let mockListItem else { throw NetworkError.noData }
        return mockListItem
    }

    func removeItem(listId: Int, tmdbMovieId: Int) async throws {
        removeItemCallCount += 1
        lastRemovedItem = (listId, tmdbMovieId)
        if let error { throw error }
    }

    func fetchItems(listId: Int) async throws -> [Movie] {
        fetchItemsCallCount += 1
        if let error { throw error }
        return mockListItems
    }

    func checkFavourite(tmdbMovieId: Int) async throws -> Bool {
        checkFavouriteCallCount += 1
        lastCheckedTmdbMovieId = tmdbMovieId
        if let error { throw error }
        return mockIsFavourite
    }

    func toggleFavourite(tmdbMovieId: Int) async throws -> Bool {
        toggleFavouriteCallCount += 1
        lastToggledTmdbMovieId = tmdbMovieId
        if let error { throw error }
        return mockToggleResult
    }
}
