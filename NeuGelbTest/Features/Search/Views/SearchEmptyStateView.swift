//
//  SearchEmptyStateView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 25.03.26.
//

import SwiftUI

struct SearchEmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            Text("Search for movies")
                .font(.headline)
            Text("Type a movie title to get started")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    SearchEmptyStateView()
}
