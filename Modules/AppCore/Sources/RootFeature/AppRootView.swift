import AppFeatures
import AuthFeature
import SwiftUI

public struct AppRootView: View {
    @State private var viewModel = AppRootViewModelFactory.make()

    public init() {}

    public var body: some View {
        @Bindable var viewModel = viewModel
        if viewModel.isAuthenticated {
            TabView(selection: $viewModel.selectedTab) {
                DiscoverTab()
                    .tabItem { Label("tab.discover", systemImage: "list.bullet") }
                    .tag(AppTab.discover)

                SearchTab()
                    .tabItem { Label("tab.search", systemImage: "magnifyingglass") }
                    .tag(AppTab.search)

                RecentlyViewedTab()
                    .tabItem { Label("tab.recentlyViewed", systemImage: "clock") }
                    .tag(AppTab.recentlyViewed)
            }
        } else {
            AuthContainer()
        }
    }
}

#Preview {
    AppRootView()
}
