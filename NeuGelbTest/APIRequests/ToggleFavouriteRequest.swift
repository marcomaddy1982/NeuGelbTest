import Foundation
import Networking

struct ToggleFavouriteRequest: NetworkRequest, Sendable {
    typealias Response = CheckFavouriteResponse

    let baseURL: URL
    let endpoint: String
    let method: HTTPMethod = .post
    let headers: [String: String]
    let queryParameters: [String: String]? = nil

    init(baseURL: URL, sessionId: String, tmdbMovieId: Int) {
        self.baseURL = baseURL
        self.endpoint = "v1/favourites/items/\(tmdbMovieId)/toggle"
        self.headers = [
            "Accept": "application/json",
            "Authorization": "Bearer \(sessionId)"
        ]
    }
}
