import Foundation
import Models
import Networking

public struct FetchListsRequest: NetworkRequest, Sendable {
    public typealias Response = [MovieList]

    public let baseURL: URL
    public let endpoint: String = "v1/lists"
    public let method: HTTPMethod = .get
    public let headers: [String: String]
    public let queryParameters: [String: String]? = nil

    public init(baseURL: URL, sessionId: String) {
        self.baseURL = baseURL
        self.headers = [
            "Accept": "application/json",
            "Authorization": "Bearer \(sessionId)"
        ]
    }
}
