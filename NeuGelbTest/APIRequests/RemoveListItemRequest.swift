import Foundation
import Networking

nonisolated struct RemoveListItemResponse: Decodable, Sendable, Equatable {}

struct RemoveListItemRequest: NetworkRequest, Sendable {
    typealias Response = RemoveListItemResponse

    let baseURL: URL
    let endpoint: String
    let method: HTTPMethod = .delete
    let headers: [String: String]
    let queryParameters: [String: String]? = nil

    init(baseURL: URL, sessionId: String, listId: Int, tmdbMovieId: Int) {
        self.baseURL = baseURL
        self.endpoint = "v1/lists/\(listId)/items/\(tmdbMovieId)"
        self.headers = [
            "Accept": "application/json",
            "Authorization": "Bearer \(sessionId)"
        ]
    }
}
