import Foundation
import Models
import Networking

public enum ListsServiceError: Error {
    case unauthenticated
}

public protocol ListsServiceProtocol {
    func fetchLists() async throws -> [MovieList]
    func createList(name: String) async throws -> MovieList
    func deleteList(id: Int) async throws
    func addItem(listId: Int, tmdbMovieId: Int) async throws -> AddListItemResponse
    func removeItem(listId: Int, tmdbMovieId: Int) async throws
    func fetchItems(listId: Int) async throws -> [Movie]
    func checkFavourite(tmdbMovieId: Int) async throws -> Bool
    func toggleFavourite(tmdbMovieId: Int) async throws -> Bool
}

public class ListsService: ListsServiceProtocol {
    @Injected<NetworkClientProtocol> var networkClient: any NetworkClientProtocol
    @Injected<KinoAPIConfig> var kinoAPIConfig: KinoAPIConfig
    @Injected<SessionManagerProtocol> var sessionManager: any SessionManagerProtocol

    public init() {}

    public func fetchLists() async throws -> [MovieList] {
        guard let sessionId = sessionManager.accessToken else { throw ListsServiceError.unauthenticated }
        let request = FetchListsRequest(baseURL: kinoAPIConfig.baseURL, sessionId: sessionId)
        return try await networkClient.fetch(request)
    }

    public func createList(name: String) async throws -> MovieList {
        guard let sessionId = sessionManager.accessToken else { throw ListsServiceError.unauthenticated }
        let request = CreateListRequest(baseURL: kinoAPIConfig.baseURL, sessionId: sessionId, name: name)
        return try await networkClient.fetch(request)
    }

    public func deleteList(id: Int) async throws {
        guard let sessionId = sessionManager.accessToken else { throw ListsServiceError.unauthenticated }
        let request = DeleteListRequest(baseURL: kinoAPIConfig.baseURL, sessionId: sessionId, listId: id)
        _ = try await networkClient.fetch(request)
    }

    public func addItem(listId: Int, tmdbMovieId: Int) async throws -> AddListItemResponse {
        guard let sessionId = sessionManager.accessToken else { throw ListsServiceError.unauthenticated }
        let request = AddListItemRequest(baseURL: kinoAPIConfig.baseURL, sessionId: sessionId, listId: listId, tmdbMovieId: tmdbMovieId)
        return try await networkClient.fetch(request)
    }

    public func removeItem(listId: Int, tmdbMovieId: Int) async throws {
        guard let sessionId = sessionManager.accessToken else { throw ListsServiceError.unauthenticated }
        let request = RemoveListItemRequest(baseURL: kinoAPIConfig.baseURL, sessionId: sessionId, listId: listId, tmdbMovieId: tmdbMovieId)
        _ = try await networkClient.fetch(request)
    }

    public func fetchItems(listId: Int) async throws -> [Movie] {
        guard let sessionId = sessionManager.accessToken else { throw ListsServiceError.unauthenticated }
        let request = FetchListItemsRequest(baseURL: kinoAPIConfig.baseURL, sessionId: sessionId, listId: listId)
        return try await networkClient.fetch(request)
    }

    public func checkFavourite(tmdbMovieId: Int) async throws -> Bool {
        guard let sessionId = sessionManager.accessToken else { throw ListsServiceError.unauthenticated }
        let request = CheckFavouriteRequest(baseURL: kinoAPIConfig.baseURL, sessionId: sessionId, tmdbMovieId: tmdbMovieId)
        let response = try await networkClient.fetch(request)
        return response.isFavourite
    }

    public func toggleFavourite(tmdbMovieId: Int) async throws -> Bool {
        guard let sessionId = sessionManager.accessToken else { throw ListsServiceError.unauthenticated }
        let request = ToggleFavouriteRequest(baseURL: kinoAPIConfig.baseURL, sessionId: sessionId, tmdbMovieId: tmdbMovieId)
        let response = try await networkClient.fetch(request)
        return response.isFavourite
    }
}
