import Foundation
import Observation

@Observable
public final class AuthRouter {
    public var path: [AuthRoute] = []

    public init() {}

    public func navigate(to route: AuthRoute) {
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
