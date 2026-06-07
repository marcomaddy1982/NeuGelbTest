import Foundation
import Networking

struct CreateSessionRequest: NetworkRequest, Sendable {
    typealias Response = AuthSession

    let baseURL: URL
    let endpoint: String = "authentication/session/new"
    let method: HTTPMethod = .post
    let headers: [String: String] = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    let queryParameters: [String: String]? = nil
    let body: Data?

    init(baseURL: URL, requestToken: String) {
        self.baseURL = baseURL
        self.body = try? JSONEncoder().encode(["request_token": requestToken])
    }
}
