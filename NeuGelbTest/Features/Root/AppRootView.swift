import SwiftUI

struct AppRootView: View {
    @State private var viewModel = AppRootViewModelFactory.make()

    var body: some View {
        @Bindable var viewModel = viewModel
        if viewModel.isAuthenticated {
            TabView(selection: $viewModel.selectedTab) {
                DiscoverTab()
                    .tabItem { Label("tab.discover", systemImage: "list.bullet") }
                    .tag(AppRootViewModel.Tab.discover)

                SearchTab()
                    .tabItem { Label("tab.search", systemImage: "magnifyingglass") }
                    .tag(AppRootViewModel.Tab.search)

                RecentlyViewedTab()
                    .tabItem { Label("tab.recentlyViewed", systemImage: "clock") }
                    .tag(AppRootViewModel.Tab.recentlyViewed)
            }
        } else {
            AuthContainer()
        }
    }
}

#Preview {
    AppRootView()
}
