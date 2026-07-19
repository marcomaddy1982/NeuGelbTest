import AppFeatures
import Foundation

@MainActor
final class ListsViewModelFactory {
    @Injected<ListsServiceProtocol> var listsService

    static func makeListsViewModel() -> ListsViewModel {
        let factory = ListsViewModelFactory()
        return ListsViewModel(listsService: factory.listsService)
    }
}
