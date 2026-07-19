import AppFeatures
import MovieDetailFeature
import RecentlyViewedFeature
import SwiftUI

struct RecentlyViewedTab: View {
    @State private var router = TabRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            RecentlyViewedView()
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
