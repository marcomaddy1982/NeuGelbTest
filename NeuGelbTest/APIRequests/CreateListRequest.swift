import Foundation
import Networking

struct CreateListRequest: NetworkRequest, Sendable {
    typealias Response = MovieList

    let baseURL: URL
    let endpoint: String = "v1/lists"
    let method: HTTPMethod = .post
    let headers: [String: String]
    let queryParameters: [String: String]? = nil
    let body: Data?

    init(baseURL: URL, sessionId: String, name: String) {
        self.baseURL = baseURL
        self.headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(sessionId)"
        ]
        self.body = try? JSONEncoder().encode(["name": name])
    }
}
