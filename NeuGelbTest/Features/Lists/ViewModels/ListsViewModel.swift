import Foundation
import Observation

enum ListsViewState {
    case loading
    case success([MovieList])
    case error(String)
}

@Observable
final class ListsViewModel {
    var state: ListsViewState = .loading

    private let listsService: any ListsServiceProtocol

    init(listsService: any ListsServiceProtocol) {
        self.listsService = listsService
    }

    func loadLists() async {
        state = .loading
        do {
            let lists = try await listsService.fetchLists()
            let sorted = lists.sorted { $0.isFavourite && !$1.isFavourite }
            state = .success(sorted)
        } catch {
            state = .error("Failed to load lists: \(error.localizedDescription)")
        }
    }

    func deleteList(id: Int) async {
        do {
            try await listsService.deleteList(id: id)
            if case .success(let lists) = state {
                let updated = lists.filter { $0.id != id }
                state = .success(updated)
            }
        } catch {
            state = .error("Failed to delete list: \(error.localizedDescription)")
        }
    }
}
