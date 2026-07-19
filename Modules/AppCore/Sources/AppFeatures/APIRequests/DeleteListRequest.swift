import Foundation
import Networking

public nonisolated struct DeleteListResponse: Decodable, Sendable, Equatable {}

public struct DeleteListRequest: NetworkRequest, Sendable {
    public typealias Response = DeleteListResponse

    public let baseURL: URL
    public let endpoint: String
    public let method: HTTPMethod = .delete
    public let headers: [String: String]
    public let queryParameters: [String: String]? = nil

    public init(baseURL: URL, sessionId: String, listId: Int) {
        self.baseURL = baseURL
        self.endpoint = "v1/lists/\(listId)"
        self.headers = [
            "Accept": "application/json",
            "Authorization": "Bearer \(sessionId)"
        ]
    }
}
