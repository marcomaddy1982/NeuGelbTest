import Foundation
import Models
import Networking

public struct CreateListRequest: NetworkRequest, Sendable {
    public typealias Response = MovieList

    public let baseURL: URL
    public let endpoint: String = "v1/lists"
    public let method: HTTPMethod = .post
    public let headers: [String: String]
    public let queryParameters: [String: String]? = nil
    public let body: Data?

    public init(baseURL: URL, sessionId: String, name: String) {
        self.baseURL = baseURL
        self.headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(sessionId)"
        ]
        self.body = try? JSONEncoder().encode(["name": name])
    }
}
