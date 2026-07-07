import Foundation
import Observation

@Observable
final class AuthRouter {
    var path: [AuthRoute] = []

    func navigate(to route: AuthRoute) {
        path.append(route)
    }

    func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
