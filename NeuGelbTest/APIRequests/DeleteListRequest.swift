import Foundation
import Networking

nonisolated struct DeleteListResponse: Decodable, Sendable, Equatable {}

struct DeleteListRequest: NetworkRequest, Sendable {
    typealias Response = DeleteListResponse

    let baseURL: URL
    let endpoint: String
    let method: HTTPMethod = .delete
    let headers: [String: String]
    let queryParameters: [String: String]? = nil

    init(baseURL: URL, sessionId: String, listId: Int) {
        self.baseURL = baseURL
        self.endpoint = "v1/lists/\(listId)"
        self.headers = [
            "Accept": "application/json",
            "Authorization": "Bearer \(sessionId)"
        ]
    }
}
