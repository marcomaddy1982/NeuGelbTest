import SwiftUI
import SwiftData

struct RecentlyResearchedView: View {
    @Query(sort: \RecentlyViewedMovie.viewedAtTimestamp, order: .reverse)
    var recentlyViewedMovies: [RecentlyViewedMovie]

    @Environment(TabRouter.self) private var router

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 160), spacing: 16)
                ],
                spacing: 16
            ) {
                ForEach(recentlyViewedMovies, id: \.tmdbId) { movie in
                    MovieCardView(viewModel: MovieCardViewModelFactory.makeMovieCardViewModel(for: movie.toMovie()), onTap: { router.navigate(to: .movieDetail($0)) })
                }
            }
            .padding()
        }
    }
}

#Preview {
    RecentlyResearchedView()
        .modelContainer(for: RecentlyViewedMovie.self, inMemory: true)
        .environment(TabRouter())
}
