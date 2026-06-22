import Foundation
import Observation

enum ListsViewState {
    case loading
    case success([KinoList])
    case empty
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
            state = lists.isEmpty ? .empty : .success(lists)
        } catch {
            state = .error("Failed to load lists: \(error.localizedDescription)")
        }
    }

    func deleteList(id: Int) async {
        do {
            try await listsService.deleteList(id: id)
            if case .success(let lists) = state {
                let updated = lists.filter { $0.id != id }
                state = updated.isEmpty ? .empty : .success(updated)
            }
        } catch {
            state = .error("Failed to delete list: \(error.localizedDescription)")
        }
    }
}
