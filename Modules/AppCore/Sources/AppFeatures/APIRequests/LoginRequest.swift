import Foundation
import Models
import Networking

public struct LoginRequest: NetworkRequest, Sendable {
    public typealias Response = AuthTokenResponse

    private struct Body: Encodable {
        let email: String
        let password: String
    }

    public let baseURL: URL
    public let endpoint: String = "v1/auth/login"
    public let method: HTTPMethod = .post
    public let headers: [String: String] = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    public let queryParameters: [String: String]? = nil
    public let body: Data?

    public init(baseURL: URL, email: String, password: String) {
        self.body = try? JSONEncoder().encode(Body(email: email, password: password))
        self.baseURL = baseURL
    }
}
