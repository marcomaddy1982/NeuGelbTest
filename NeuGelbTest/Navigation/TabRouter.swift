import Foundation
import Observation

@Observable
final class TabRouter {
    var path: [TabRoute] = []

    func navigate(to route: TabRoute) {
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
