import Foundation

public final class KinoAPIConfig: Sendable {
    public let baseURL: URL

    public init() {
        baseURL = URL(string: "https://kino-api-zozt.onrender.com")!
    }
}
