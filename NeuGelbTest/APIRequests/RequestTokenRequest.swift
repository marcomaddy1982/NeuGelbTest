import Foundation
import Networking

struct RequestTokenRequest: NetworkRequest, Sendable {
    typealias Response = RequestToken

    let baseURL: URL
    let endpoint: String = "authentication/token/new"
    let method: HTTPMethod = .get
    let headers: [String: String]
    let queryParameters: [String: String]? = nil

    init(baseURL: URL, accessToken: String) {
        self.baseURL = baseURL
        self.headers = ["Accept": "application/json", "Authorization": "Bearer \(accessToken)"]
    }
}
