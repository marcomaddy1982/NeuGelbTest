import Foundation
import Networking

enum ListsServiceError: Error {
    case unauthenticated
}

protocol ListsServiceProtocol {
    func fetchLists() async throws -> [KinoList]
    func createList(name: String) async throws -> KinoList
    func deleteList(id: Int) async throws
    func addItem(listId: Int, tmdbMovieId: Int) async throws -> KinoListItem
    func removeItem(listId: Int, tmdbMovieId: Int) async throws
}

class ListsService: ListsServiceProtocol {
    @Injected<NetworkClientProtocol> var networkClient: any NetworkClientProtocol
    @Injected<KinoAPIConfig> var kinoAPIConfig: KinoAPIConfig
    @Injected<SessionManagerProtocol> var sessionManager: any SessionManagerProtocol

    func fetchLists() async throws -> [KinoList] {
        guard let sessionId = sessionManager.sessionId else { throw ListsServiceError.unauthenticated }
        let request = FetchListsRequest(baseURL: kinoAPIConfig.baseURL, sessionId: sessionId)
        return try await networkClient.fetch(request)
    }

    func createList(name: String) async throws -> KinoList {
        guard let sessionId = sessionManager.sessionId else { throw ListsServiceError.unauthenticated }
        let request = CreateListRequest(baseURL: kinoAPIConfig.baseURL, sessionId: sessionId, name: name)
        return try await networkClient.fetch(request)
    }

    func deleteList(id: Int) async throws {
        guard let sessionId = sessionManager.sessionId else { throw ListsServiceError.unauthenticated }
        let request = DeleteListRequest(baseURL: kinoAPIConfig.baseURL, sessionId: sessionId, listId: id)
        _ = try await networkClient.fetch(request)
    }

    func addItem(listId: Int, tmdbMovieId: Int) async throws -> KinoListItem {
        guard let sessionId = sessionManager.sessionId else { throw ListsServiceError.unauthenticated }
        let request = AddListItemRequest(baseURL: kinoAPIConfig.baseURL, sessionId: sessionId, listId: listId, tmdbMovieId: tmdbMovieId)
        return try await networkClient.fetch(request)
    }

    func removeItem(listId: Int, tmdbMovieId: Int) async throws {
        guard let sessionId = sessionManager.sessionId else { throw ListsServiceError.unauthenticated }
        let request = RemoveListItemRequest(baseURL: kinoAPIConfig.baseURL, sessionId: sessionId, listId: listId, tmdbMovieId: tmdbMovieId)
        _ = try await networkClient.fetch(request)
    }
}
