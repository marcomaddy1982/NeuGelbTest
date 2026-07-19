import Foundation
import Models
import Networking

public struct ToggleFavouriteRequest: NetworkRequest, Sendable {
    public typealias Response = CheckFavouriteResponse

    public let baseURL: URL
    public let endpoint: String
    public let method: HTTPMethod = .post
    public let headers: [String: String]
    public let queryParameters: [String: String]? = nil

    public init(baseURL: URL, sessionId: String, tmdbMovieId: Int) {
        self.baseURL = baseURL
        self.endpoint = "v1/favourites/items/\(tmdbMovieId)/toggle"
        self.headers = [
            "Accept": "application/json",
            "Authorization": "Bearer \(sessionId)"
        ]
    }
}
