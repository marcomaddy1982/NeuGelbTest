import AppFeatures
import Foundation
import Models

@MainActor
final class ListDetailViewModelFactory {
    @Injected<ListsServiceProtocol> var listsService

    static func makeListDetailViewModel(list: MovieList) -> ListDetailViewModel {
        let factory = ListDetailViewModelFactory()
        return ListDetailViewModel(list: list, listsService: factory.listsService)
    }
}
