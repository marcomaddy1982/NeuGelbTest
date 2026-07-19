import Foundation
import Observation

@Observable
public final class TabRouter {
    public var path: [TabRoute] = []

    public init() {}

    public func navigate(to route: TabRoute) {
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
