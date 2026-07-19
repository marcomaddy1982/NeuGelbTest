import AppFeatures
import SwiftUI

public struct AuthContainer: View {
    @State private var router = AuthRouter()

    public init() {}

    public var body: some View {
        NavigationStack(path: $router.path) {
            LoginView()
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .register:
                        RegisterView()
                    }
                }
        }
        .environment(router)
    }
}

#Preview {
    AuthContainer()
}
