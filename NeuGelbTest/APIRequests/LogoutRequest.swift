import Foundation
import Networking

struct LogoutRequest: NetworkRequest, Sendable {
    typealias Response = Data

    private struct Body: Encodable {
        let refreshToken: String

        enum CodingKeys: String, CodingKey {
            case refreshToken = "refresh_token"
        }
    }

    let baseURL: URL
    let endpoint: String = "v1/auth/logout"
    let method: HTTPMethod = .delete
    let headers: [String: String] = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    let queryParameters: [String: String]? = nil
    let body: Data?

    init(baseURL: URL, refreshToken: String) {
        self.baseURL = baseURL
        self.body = try? JSONEncoder().encode(Body(refreshToken: refreshToken))
    }
}
