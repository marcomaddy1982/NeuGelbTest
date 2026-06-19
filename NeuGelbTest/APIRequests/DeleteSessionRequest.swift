import Foundation
import Networking

struct DeleteSessionRequest: NetworkRequest, Sendable {
    typealias Response = DeleteSessionResponse

    let baseURL: URL
    let endpoint: String = "authentication/session"
    let method: HTTPMethod = .delete
    let headers: [String: String]
    let queryParameters: [String: String]? = nil
    let body: Data?

    init(baseURL: URL, accessToken: String, sessionId: String) {
        self.baseURL = baseURL
        self.headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        self.body = try? JSONEncoder().encode(["session_id": sessionId])
    }
}
