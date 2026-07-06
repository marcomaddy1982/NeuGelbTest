import Foundation
import Networking

struct RegisterRequest: NetworkRequest, Sendable {
    typealias Response = AuthTokenResponse

    private struct Body: Encodable {
        let email: String
        let password: String
        let name: String
        let phoneNumber: String

        enum CodingKeys: String, CodingKey {
            case email, password, name
            case phoneNumber = "phone_number"
        }
    }

    let baseURL: URL
    let endpoint: String = "v1/auth/register"
    let method: HTTPMethod = .post
    let headers: [String: String] = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    let queryParameters: [String: String]? = nil
    let body: Data?

    init(baseURL: URL, email: String, password: String, name: String, phoneNumber: String) {
        self.baseURL = baseURL
        self.body = try? JSONEncoder().encode(Body(email: email, password: password, name: name, phoneNumber: phoneNumber))
    }
}
