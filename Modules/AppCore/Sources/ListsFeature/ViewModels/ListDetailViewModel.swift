import AppFeatures
import Foundation
import Models
import Observation

enum ListDetailViewState {
    case loading
    case success([Movie])
    case error(String)
}

@Observable
final class ListDetailViewModel {
    var state: ListDetailViewState = .loading
    let list: MovieList

    private let listsService: any ListsServiceProtocol

    init(list: MovieList, listsService: any ListsServiceProtocol) {
        self.list = list
        self.listsService = listsService
    }

    func load() async {
        do {
            let items = try await listsService.fetchItems(listId: list.id)
            state = .success(items)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
