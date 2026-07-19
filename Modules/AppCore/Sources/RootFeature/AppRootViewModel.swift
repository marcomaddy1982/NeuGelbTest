import AppFeatures
import Observation
import SettingsFeature
import SwiftUI

@Observable
final class AppRootViewModel {
    @ObservationIgnored @AppStorage("defaultTab") private var defaultTab: DefaultTab = .discover
    @ObservationIgnored @Injected<SessionManagerProtocol> private var sessionManager: any SessionManagerProtocol

    var isAuthenticated: Bool { sessionManager.accessToken != nil }
    var selectedTab: AppTab

    init() {
        selectedTab = .discover
        selectedTab = defaultTab.tab
    }
}
