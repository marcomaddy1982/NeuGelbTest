//
//  AppRootView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import SwiftUI

struct AppRootView: View {
    @State private var selectedTab: Tab = .discover
    
    enum Tab {
        case discover
        case search
        case recentlyViewed
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MovieListView()
                .tabItem {
                    Label("Discover", systemImage: "list.bullet")
                }
                .tag(Tab.discover)
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(Tab.search)
            
            RecentlyViewedView()
                .tabItem {
                    Label("Recently Viewed", systemImage: "clock")
                }
                .tag(Tab.recentlyViewed)
        }
    }
}

#Preview {
    AppRootView()
}
