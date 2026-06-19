import Foundation
import Networking

struct AddListItemRequest: NetworkRequest, Sendable {
    typealias Response = KinoListItem

    let baseURL: URL
    let endpoint: String
    let method: HTTPMethod = .post
    let headers: [String: String]
    let queryParameters: [String: String]? = nil
    let body: Data?

    init(baseURL: URL, sessionId: String, listId: Int, tmdbMovieId: Int) {
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
