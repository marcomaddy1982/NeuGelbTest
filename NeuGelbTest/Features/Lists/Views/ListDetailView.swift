import SwiftUI

struct ListDetailView: View {
    @State var viewModel: ListDetailViewModel

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .success(let items):
                if items.isEmpty {
                    ContentUnavailableView(
                        String(localized: "listDetail.empty.title"),
                        systemImage: "film",
                        description: Text("listDetail.empty.subtitle")
                    )
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 160), spacing: 16)],
                            spacing: 16
                        ) {
                            ForEach(items) { item in
                                MovieCardView(viewModel: MovieCardViewModelFactory.makeMovieCardViewModel(for: item))
                            }
                        }
                        .padding()
                    }
                }
            case .error(let message):
                ContentUnavailableView(message, systemImage: "exclamationmark.triangle")
            }
        }
        .navigationTitle(viewModel.list.name)
        .navigationBarTitleDisplayMode(.large)
        .task { await viewModel.load() }
    }
}
