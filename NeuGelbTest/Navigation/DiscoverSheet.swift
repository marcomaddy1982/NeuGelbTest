import Foundation

enum DiscoverSheet: Identifiable, Hashable {
    case lists
    case settings

    var id: Self { self }
}
