import SwiftUI

enum DefaultTab: String, CaseIterable {
    case discover
    case search
    case recentlyViewed

    var tab: AppRootViewModel.Tab {
        switch self {
        case .discover:       return .discover
        case .search:         return .search
        case .recentlyViewed: return .recentlyViewed
        }
    }

    var label: LocalizedStringKey {
        switch self {
        case .discover:       return "tab.discover"
        case .search:         return "tab.search"
        case .recentlyViewed: return "tab.recentlyViewed"
        }
    }
}
