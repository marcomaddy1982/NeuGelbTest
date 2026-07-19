import Foundation
import Networking

public struct LogoutRequest: NetworkRequest, Sendable {
    public typealias Response = Data

    private struct Body: Encodable {
        let refreshToken: String

        enum CodingKeys: String, CodingKey {
            case refreshToken = "refresh_token"
        }
    }

    public let baseURL: URL
    public let endpoint: String = "v1/auth/logout"
    public let method: HTTPMethod = .delete
    public let headers: [String: String] = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    public let queryParameters: [String: String]? = nil
    public let body: Data?

    public init(baseURL: URL, refreshToken: String) {
        self.baseURL = baseURL
        self.body = try? JSONEncoder().encode(Body(refreshToken: refreshToken))
    }
}
