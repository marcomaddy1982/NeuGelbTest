import SwiftUI

struct MovieListView: View {
    @State private var viewModel = MovieListViewModelFactory.makeMovieListViewModel()
    @Environment(TabRouter.self) private var router
    @Environment(\.discoverSheet) private var presentedSheet

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                MovieListLoadingView()

            case .success(let movies):
                MovieListSuccessView(movies: movies, viewModel: viewModel)

            case .error(let errorMessage):
                ErrorStateView(errorMessage: errorMessage, onRetry: {
                    await viewModel.loadMovies()
                })
            }
        }
        .navigationTitle("movieList.navigationTitle")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentedSheet.wrappedValue = .lists
                } label: {
                    Image(systemName: "list.bullet")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    presentedSheet.wrappedValue = .settings
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .task(id: viewModel.state) {
            if case .loading = viewModel.state {
                await viewModel.loadMovies()
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieListView()
    }
    .environment(TabRouter())
}
