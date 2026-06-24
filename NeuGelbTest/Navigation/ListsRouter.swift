import Foundation
import Observation

@Observable
final class ListsRouter {
    var path: [AppRoutePath] = []

    func navigate(to route: AppRoute) {
        path.append(AppRoutePath(route))
    }

    func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
