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

    var lastCreatedListName: String?
    var lastDeletedListId: Int?
    var lastAddedItem: (listId: Int, tmdbMovieId: Int)?
    var lastRemovedItem: (listId: Int, tmdbMovieId: Int)?

    var mockLists: [KinoList] = []
    var mockList: KinoList?
    var mockListItem: KinoListItem?

    func fetchLists() async throws -> [KinoList] {
        fetchListsCallCount += 1
        if let error { throw error }
        return mockLists
    }

    func createList(name: String) async throws -> KinoList {
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

    func addItem(listId: Int, tmdbMovieId: Int) async throws -> KinoListItem {
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
}
