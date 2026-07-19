import Foundation
import Models

public enum ListRoute: Hashable {
    case listDetail(MovieList)
    case movieDetail(Movie)
}
