import SwiftUI
import Observation

@Observable
final class AppRootViewModel {

    enum Tab {
        case discover
        case search
        case recentlyViewed
    }

    @ObservationIgnored @AppStorage("defaultTab") private var defaultTab: DefaultTab = .discover
    @ObservationIgnored @Injected<SessionManagerProtocol> private var sessionManager: any SessionManagerProtocol

    var isAuthenticated: Bool { sessionManager.accessToken != nil }
    var selectedTab: Tab

    init() {
        selectedTab = .discover
        selectedTab = defaultTab.tab
    }
}
