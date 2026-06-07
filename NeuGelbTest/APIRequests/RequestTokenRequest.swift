import Foundation
import Networking

struct RequestTokenRequest: NetworkRequest, Sendable {
    typealias Response = RequestToken

    let baseURL: URL
    let endpoint: String = "authentication/token/new"
    let method: HTTPMethod = .get
    let headers: [String: String] = ["Accept": "application/json"]
    let queryParameters: [String: String]? = nil

    init(baseURL: URL) {
        self.baseURL = baseURL
    }
}
