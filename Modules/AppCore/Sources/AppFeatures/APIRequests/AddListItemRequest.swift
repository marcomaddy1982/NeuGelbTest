import Foundation
import Models
import Networking

public struct AddListItemRequest: NetworkRequest, Sendable {
    public typealias Response = AddListItemResponse

    public let baseURL: URL
    public let endpoint: String
    public let method: HTTPMethod = .post
    public let headers: [String: String]
    public let queryParameters: [String: String]? = nil
    public let body: Data?

    public init(baseURL: URL, sessionId: String, listId: Int, tmdbMovieId: Int) {
        self.baseURL = baseURL
        self.endpoint = "v1/lists/\(listId)/items"
        self.headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(sessionId)"
        ]
        self.body = try? JSONEncoder().encode(["tmdb_movie_id": tmdbMovieId])
    }
}
