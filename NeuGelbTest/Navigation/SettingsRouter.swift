import Foundation
import Observation

@Observable
final class SettingsRouter {
    var path: [SettingsRoute] = []

    func navigate(to route: SettingsRoute) {
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
