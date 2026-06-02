//
//  AppRootView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import SwiftUI

struct AppRootView: View {
    @AppStorage("defaultTab") private var defaultTab: DefaultTab = .discover
    @State private var selectedTab: Tab = .discover
    @State private var showSettings: Bool = false

    enum Tab {
        case discover
        case search
        case recentlyViewed
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                MovieListView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showSettings = true
                            } label: {
                                Image(systemName: "gearshape")
                            }
                        }
                    }
            }
            .tabItem {
                Label("tab.discover", systemImage: "list.bullet")
            }
            .tag(Tab.discover)

            SearchView()
                .tabItem {
                    Label("tab.search", systemImage: "magnifyingglass")
                }
                .tag(Tab.search)

            RecentlyViewedView()
                .tabItem {
                    Label("tab.recentlyViewed", systemImage: "clock")
                }
                .tag(Tab.recentlyViewed)
        }
        .onAppear {
            selectedTab = defaultTab.tab
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

#Preview {
    AppRootView()
}
