import AppFeatures
import Foundation
import Models
import Networking
import Testing
import TestSupport


@Suite("ListsService Tests")
@MainActor
struct ListsServiceTests {

    private func makeSUT(accessToken: String? = "test-access-token") -> (ListsService, MockNetworkClient, MockSessionManager) {
        let mockNetworkClient = MockNetworkClient()
        let mockSessionManager = MockSessionManager()
        mockSessionManager.accessToken = accessToken

        DIContainer.shared.reset()
        DIContainer.shared.register(mockNetworkClient as NetworkClientProtocol)
        DIContainer.shared.register(KinoAPIConfig())
        DIContainer.shared.register(mockSessionManager as SessionManagerProtocol)

        return (ListsService(), mockNetworkClient, mockSessionManager)
    }

    // MARK: - fetchLists

    @Test("fetchLists returns decoded lists")
    func testFetchListsReturnsLists() async throws {
        let (sut, mockClient, _) = makeSUT()
        let json = #"[{"id":1,"name":"Watchlist","isFavourite":false,"createdAt":"2026-01-01T00:00:00.000Z","itemCount":0}]"#.data(using: .utf8)!
        mockClient.simulateSuccess(with: json)

        let lists = try await sut.fetchLists()

        #expect(lists.count == 1)
        #expect(lists.first?.name == "Watchlist")
    }

    @Test("fetchLists throws when unauthenticated")
    func testFetchListsThrowsWhenUnauthenticated() async {
        let (sut, _, _) = makeSUT(accessToken: nil)

        await #expect(throws: ListsServiceError.unauthenticated) {
            try await sut.fetchLists()
        }
    }

    @Test("fetchLists throws on network error")
    func testFetchListsThrowsOnNetworkError() async {
        let (sut, mockClient, _) = makeSUT()
        mockClient.simulateFailure(with: .noData)

        await #expect(throws: (any Error).self) {
            try await sut.fetchLists()
        }
    }

    // MARK: - fetchItems

    @Test("fetchItems returns decoded items")
    func testFetchItemsReturnsItems() async throws {
        let (sut, mockClient, _) = makeSUT()
        let json = #"[{"id":550,"title":"Fight Club","poster_path":"/fc.jpg","vote_average":8.4,"release_date":"1999-10-15"}]"#.data(using: .utf8)!
        mockClient.simulateSuccess(with: json)

        let items = try await sut.fetchItems(listId: 1)

        #expect(items.count == 1)
        #expect(items.first?.tmdbId == 550)
    }

    @Test("fetchItems throws when unauthenticated")
    func testFetchItemsThrowsWhenUnauthenticated() async {
        let (sut, _, _) = makeSUT(accessToken: nil)

        await #expect(throws: ListsServiceError.unauthenticated) {
            try await sut.fetchItems(listId: 1)
        }
    }

    // MARK: - createList

    @Test("createList returns new list")
    func testCreateListReturnsNewList() async throws {
        let (sut, mockClient, _) = makeSUT()
        let json = #"{"id":2,"name":"Horror","isFavourite":false,"createdAt":"2026-01-01T00:00:00.000Z","itemCount":0}"#.data(using: .utf8)!
        mockClient.simulateSuccess(with: json)

        let list = try await sut.createList(name: "Horror")

        #expect(list.name == "Horror")
        #expect(list.isFavourite == false)
    }

    @Test("createList throws when unauthenticated")
    func testCreateListThrowsWhenUnauthenticated() async {
        let (sut, _, _) = makeSUT(accessToken: nil)

        await #expect(throws: ListsServiceError.unauthenticated) {
            try await sut.createList(name: "Horror")
        }
    }

    // MARK: - deleteList

    @Test("deleteList succeeds without error")
    func testDeleteListSucceeds() async throws {
        let (sut, mockClient, _) = makeSUT()
        mockClient.simulateSuccess(with: "{}".data(using: .utf8)!)

        try await sut.deleteList(id: 1)
    }

    @Test("deleteList throws when unauthenticated")
    func testDeleteListThrowsWhenUnauthenticated() async {
        let (sut, _, _) = makeSUT(accessToken: nil)

        await #expect(throws: ListsServiceError.unauthenticated) {
            try await sut.deleteList(id: 1)
        }
    }

    // MARK: - addItem

    @Test("addItem returns list item")
    func testAddItemReturnsListItem() async throws {
        let (sut, mockClient, _) = makeSUT()
        let json = #"{"tmdbMovieId":550}"#.data(using: .utf8)!
        mockClient.simulateSuccess(with: json)

        let item = try await sut.addItem(listId: 1, tmdbMovieId: 550)

        #expect(item.tmdbMovieId == 550)
    }

    @Test("addItem throws when unauthenticated")
    func testAddItemThrowsWhenUnauthenticated() async {
        let (sut, _, _) = makeSUT(accessToken: nil)

        await #expect(throws: ListsServiceError.unauthenticated) {
            try await sut.addItem(listId: 1, tmdbMovieId: 550)
        }
    }

    // MARK: - removeItem

    @Test("removeItem succeeds without error")
    func testRemoveItemSucceeds() async throws {
        let (sut, mockClient, _) = makeSUT()
        mockClient.simulateSuccess(with: "{}".data(using: .utf8)!)

        try await sut.removeItem(listId: 1, tmdbMovieId: 550)
    }

    @Test("removeItem throws when unauthenticated")
    func testRemoveItemThrowsWhenUnauthenticated() async {
        let (sut, _, _) = makeSUT(accessToken: nil)

        await #expect(throws: ListsServiceError.unauthenticated) {
            try await sut.removeItem(listId: 1, tmdbMovieId: 550)
        }
    }
}
