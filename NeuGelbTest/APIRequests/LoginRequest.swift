import Foundation
import Networking

struct LoginRequest: NetworkRequest, Sendable {
    typealias Response = AuthTokenResponse

    private struct Body: Encodable {
        let email: String
        let password: String
    }

    let baseURL: URL
    let endpoint: String = "v1/auth/login"
    let method: HTTPMethod = .post
    let headers: [String: String] = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    let queryParameters: [String: String]? = nil
    let body: Data?

    init(baseURL: URL, email: String, password: String) {
        self.body = try? JSONEncoder().encode(Body(email: email, password: password))
        self.baseURL = baseURL
    }
}
