import Foundation

final class KinoAPIConfig: Sendable {
    let baseURL: URL

    init() {
        baseURL = URL(string: "https://kino-api-zozt.onrender.com")!
    }
}
