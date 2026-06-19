import Foundation

final class KinoAPIConfig: Sendable {
    let baseURL: URL

    init() {
        baseURL = URL(string: "http://localhost:3000")!
    }
}
