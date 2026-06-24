import Foundation
import Networking

struct FetchListItemsRequest: NetworkRequest, Sendable {
    typealias Response = [Movie]
    let baseURL: URL
    let endpoint: String
    let method: HTTPMethod = .get
    let headers: [String: String]
    let queryParameters: [String: String]? = nil

    init(baseURL: URL, sessionId: String, listId: Int) {
        self.baseURL = baseURL
        self.endpoint = "v1/lists/\(listId)/items"
        self.headers = ["Accept": "application/json", "Authorization": "Bearer \(sessionId)"]
    }
}
