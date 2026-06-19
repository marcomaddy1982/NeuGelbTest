import Foundation

public protocol NetworkClientProtocol: Sendable {
    func fetch<R: NetworkRequest>(_ request: R) async throws -> R.Response
}
