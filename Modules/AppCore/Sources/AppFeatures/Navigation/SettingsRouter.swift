import Foundation
import Observation

@Observable
public final class SettingsRouter {
    public var path: [SettingsRoute] = []

    public init() {}

    public func navigate(to route: SettingsRoute) {
        path.append(route)
    }

    public func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    public func popToRoot() {
        path.removeAll()
    }
}
