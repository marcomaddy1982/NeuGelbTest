import Foundation

struct AppRoutePath: Hashable {
    var route: AppRoute
    private let id = UUID()

    init(_ route: AppRoute) {
        self.route = route
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: AppRoutePath, rhs: AppRoutePath) -> Bool {
        lhs.route == rhs.route
    }
}
