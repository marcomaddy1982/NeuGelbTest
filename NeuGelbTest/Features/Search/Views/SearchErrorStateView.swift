//
//  SearchErrorStateView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 25.03.26.
//

import SwiftUI

struct SearchErrorStateView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 48))
                .foregroundColor(.red)
            Text("Search Error")
                .font(.headline)
            Text(message)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SearchErrorStateView(message: "An error occurred while searching. Please try again.")
}
