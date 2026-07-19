import Foundation

public enum DiscoverSheet: Identifiable, Hashable {
    case lists
    case settings

    public var id: Self { self }
}
