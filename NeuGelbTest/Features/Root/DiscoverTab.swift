import SwiftUI

struct DiscoverTab: View {
    @State private var router = TabRouter()
    @State private var presentedSheet: DiscoverSheet?

    var body: some View {
        NavigationStack(path: $router.path) {
            MovieListView()
                .navigationDestination(for: TabRoute.self) { route in
                    switch route {
                    case .movieDetail(let movie):
                        MovieDetailView(movie: movie)
                    }
                }
        }
        .sheet(item: $presentedSheet) { sheet in
            switch sheet {
            case .lists:
                ListsSheet()
            case .settings:
                SettingsSheet()
            }
        }
        .environment(router)
        .environment(\.discoverSheet, $presentedSheet)
    }
}
