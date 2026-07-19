import AppFeatures
import MovieDetailFeature
import SwiftUI

public struct ListsSheet: View {
    @State private var router = ListsRouter()

    public init() {}

    public var body: some View {
        NavigationStack(path: $router.path) {
            ListsView()
                .navigationDestination(for: ListRoute.self) { route in
                    switch route {
                    case .listDetail(let list):
                        ListDetailView(viewModel: ListDetailViewModelFactory.makeListDetailViewModel(list: list))
                    case .movieDetail(let movie):
                        MovieDetailView(movie: movie)
                    }
                }
        }
        .environment(router)
    }
}

#Preview {
    ListsSheet()
}
