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
    }
}

#Preview {
    AppRootView()
}
