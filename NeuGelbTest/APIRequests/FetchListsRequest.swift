import Foundation
import Networking

struct FetchListsRequest: NetworkRequest, Sendable {
    typealias Response = [KinoList]

    let baseURL: URL
    let endpoint: String = "v1/lists"
    let method: HTTPMethod = .get
    let headers: [String: String]
    let queryParameters: [String: String]? = nil

    init(baseURL: URL, sessionId: String) {
        self.baseURL = baseURL
        self.headers = [
            "Accept": "application/json",
            "Authorization": "Bearer \(sessionId)"
        ]
    }
}
