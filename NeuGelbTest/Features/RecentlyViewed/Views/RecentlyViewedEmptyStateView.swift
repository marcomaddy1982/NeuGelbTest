//
//  RecentlyViewedEmptyStateView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 27.03.26.
//

import SwiftUI

struct RecentlyViewedEmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("No Recently Viewed Movies")
                .font(.headline)
            
            Text("Movies you watch will appear here")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    RecentlyViewedEmptyStateView()
}
