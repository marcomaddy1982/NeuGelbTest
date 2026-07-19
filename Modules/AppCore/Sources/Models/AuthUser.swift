import Foundation

public nonisolated struct AuthUser: Decodable, Sendable {
    public let id: Int
    public let email: String
    public let name: String
    public let phoneNumber: String?

    public init(id: Int, email: String, name: String, phoneNumber: String?) {
        self.id = id
        self.email = email
        self.name = name
        self.phoneNumber = phoneNumber
    }
}
