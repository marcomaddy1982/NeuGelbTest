import SwiftUI

struct SearchTab: View {
    @State private var router = TabRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            SearchView()
                .navigationDestination(for: TabRoute.self) { route in
                    switch route {
                    case .movieDetail(let movie):
                        MovieDetailView(movie: movie)
                    }
                }
        }
        .environment(router)
    }
}
