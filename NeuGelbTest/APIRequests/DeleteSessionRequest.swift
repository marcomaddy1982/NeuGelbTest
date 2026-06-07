import Foundation
import Networking

struct DeleteSessionRequest: NetworkRequest, Sendable {
    typealias Response = DeleteSessionResponse

    let baseURL: URL
    let endpoint: String = "authentication/session"
    let method: HTTPMethod = .delete
    let headers: [String: String] = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    let queryParameters: [String: String]? = nil
    let body: Data?

    init(baseURL: URL, sessionId: String) {
        self.baseURL = baseURL
        self.body = try? JSONEncoder().encode(["session_id": sessionId])
    }
}
