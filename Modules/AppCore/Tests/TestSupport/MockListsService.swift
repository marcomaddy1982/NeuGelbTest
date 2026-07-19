import AppFeatures
import Foundation
import Models
import Networking

public final class MockListsService: ListsServiceProtocol {
    public var shouldSucceed: Bool = true
    public var error: Error?

    public var fetchListsCallCount: Int = 0
    public var createListCallCount: Int = 0
    public var deleteListCallCount: Int = 0
    public var addItemCallCount: Int = 0
    public var removeItemCallCount: Int = 0
    public var fetchItemsCallCount: Int = 0
    public var checkFavouriteCallCount: Int = 0
    public var toggleFavouriteCallCount: Int = 0

    public var lastCreatedListName: String?
    public var lastDeletedListId: Int?
    public var lastAddedItem: (listId: Int, tmdbMovieId: Int)?
    public var lastRemovedItem: (listId: Int, tmdbMovieId: Int)?
    public var lastCheckedTmdbMovieId: Int?
    public var lastToggledTmdbMovieId: Int?

    public var mockIsFavourite: Bool = false
    public var mockToggleResult: Bool = true

    public var mockLists: [MovieList] = []
    public var mockList: MovieList?
    public var mockListItem: AddListItemResponse?
    public var mockListItems: [Movie] = []

    public init() {}

    public func fetchLists() async throws -> [MovieList] {
        fetchListsCallCount += 1
        if let error { throw error }
        return mockLists
    }

    public func createList(name: String) async throws -> MovieList {
        createListCallCount += 1
        lastCreatedListName = name
        if let error { throw error }
        guard let mockList else { throw NetworkError.noData }
        return mockList
    }

    public func deleteList(id: Int) async throws {
        deleteListCallCount += 1
        lastDeletedListId = id
        if let error { throw error }
    }

    public func addItem(listId: Int, tmdbMovieId: Int) async throws -> AddListItemResponse {
        addItemCallCount += 1
        lastAddedItem = (listId, tmdbMovieId)
        if let error { throw error }
        guard let mockListItem else { throw NetworkError.noData }
        return mockListItem
    }

    public func removeItem(listId: Int, tmdbMovieId: Int) async throws {
        removeItemCallCount += 1
        lastRemovedItem = (listId, tmdbMovieId)
        if let error { throw error }
    }

    public func fetchItems(listId: Int) async throws -> [Movie] {
        fetchItemsCallCount += 1
        if let error { throw error }
        return mockListItems
    }

    public func checkFavourite(tmdbMovieId: Int) async throws -> Bool {
        checkFavouriteCallCount += 1
        lastCheckedTmdbMovieId = tmdbMovieId
        if let error { throw error }
        return mockIsFavourite
    }

    public func toggleFavourite(tmdbMovieId: Int) async throws -> Bool {
        toggleFavouriteCallCount += 1
        lastToggledTmdbMovieId = tmdbMovieId
        if let error { throw error }
        return mockToggleResult
    }
}
