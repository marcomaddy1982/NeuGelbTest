//
//  MovieDetailLoadingView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 27.03.26.
//

import SwiftUI

struct MovieDetailLoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("movieDetail.loading")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    MovieDetailLoadingView()
}
