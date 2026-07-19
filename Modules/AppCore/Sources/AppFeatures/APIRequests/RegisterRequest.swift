import Foundation
import Models
import Networking

public struct RegisterRequest: NetworkRequest, Sendable {
    public typealias Response = AuthTokenResponse

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

    public let baseURL: URL
    public let endpoint: String = "v1/auth/register"
    public let method: HTTPMethod = .post
    public let headers: [String: String] = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    public let queryParameters: [String: String]? = nil
    public let body: Data?

    public init(baseURL: URL, email: String, password: String, name: String, phoneNumber: String) {
        self.baseURL = baseURL
        self.body = try? JSONEncoder().encode(Body(email: email, password: password, name: name, phoneNumber: phoneNumber))
    }
}
