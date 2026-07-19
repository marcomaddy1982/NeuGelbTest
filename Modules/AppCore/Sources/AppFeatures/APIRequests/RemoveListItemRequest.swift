import Foundation
import Networking

public nonisolated struct RemoveListItemResponse: Decodable, Sendable, Equatable {}

public struct RemoveListItemRequest: NetworkRequest, Sendable {
    public typealias Response = RemoveListItemResponse

    public let baseURL: URL
    public let endpoint: String
    public let method: HTTPMethod = .delete
    public let headers: [String: String]
    public let queryParameters: [String: String]? = nil

    public init(baseURL: URL, sessionId: String, listId: Int, tmdbMovieId: Int) {
        self.baseURL = baseURL
        self.endpoint = "v1/lists/\(listId)/items/\(tmdbMovieId)"
        self.headers = [
            "Accept": "application/json",
            "Authorization": "Bearer \(sessionId)"
        ]
    }
}
