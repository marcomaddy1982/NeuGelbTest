import Foundation
import Models
import Networking

public struct FetchListItemsRequest: NetworkRequest, Sendable {
    public typealias Response = [Movie]
    public let baseURL: URL
    public let endpoint: String
    public let method: HTTPMethod = .get
    public let headers: [String: String]
    public let queryParameters: [String: String]? = nil

    public init(baseURL: URL, sessionId: String, listId: Int) {
        self.baseURL = baseURL
        self.endpoint = "v1/lists/\(listId)/items"
        self.headers = ["Accept": "application/json", "Authorization": "Bearer \(sessionId)"]
    }
}
