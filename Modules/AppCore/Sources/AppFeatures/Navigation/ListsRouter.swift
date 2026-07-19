import Foundation
import Observation

@Observable
public final class ListsRouter {
    public var path: [ListRoute] = []

    public init() {}

    public func navigate(to route: ListRoute) {
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
