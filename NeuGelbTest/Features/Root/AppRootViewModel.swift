//
//  AppRootViewModel.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 04.06.26.
//

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

    var isAuthenticated: Bool { sessionManager.sessionId != nil }
    var selectedTab: Tab
    var discoverRouter = AppRouter()
    var searchRouter = AppRouter()
    var recentlyViewedRouter = AppRouter()

    init() {
        selectedTab = .discover
        selectedTab = defaultTab.tab
    }
}
