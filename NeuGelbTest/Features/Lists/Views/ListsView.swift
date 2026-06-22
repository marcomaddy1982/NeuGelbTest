import SwiftUI

@MainActor
struct ListsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = ListsViewModelFactory.makeListsViewModel()

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .empty:
                EmptyStateView(
                    icon: "list.bullet",
                    title: "lists.empty.title",
                    message: "lists.empty.subtitle"
                )
            case .success(let lists):
                List {
                    ForEach(lists) { list in
                        HStack {
                            Text(list.name)
                            Spacer()
                            if list.isFavourite {
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            if !list.isFavourite {
                                Button(role: .destructive) {
                                    Task { await viewModel.deleteList(id: list.id) }
                                } label: {
                                    Label("common.delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            case .error(let message):
                ErrorStateView(
                    errorMessage: message,
                    onRetry: { await viewModel.loadLists() }
                )
            }
        }
        .navigationTitle("lists.navigationTitle")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        .task {
            await viewModel.loadLists()
        }
    }
}

#Preview {
    NavigationStack {
        ListsView()
    }
}
