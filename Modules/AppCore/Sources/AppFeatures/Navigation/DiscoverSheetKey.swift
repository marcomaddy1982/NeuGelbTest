import SwiftUI

private struct DiscoverSheetKey: EnvironmentKey {
    static let defaultValue: Binding<DiscoverSheet?> = .constant(nil)
}

extension EnvironmentValues {
    public var discoverSheet: Binding<DiscoverSheet?> {
        get { self[DiscoverSheetKey.self] }
        set { self[DiscoverSheetKey.self] = newValue }
    }
}
