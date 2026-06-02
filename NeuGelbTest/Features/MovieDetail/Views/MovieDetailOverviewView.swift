//
//  MovieDetailOverviewView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import SwiftUI

struct MovieDetailOverviewView: View {
    let overview: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("movieDetail.overview")
                .headlineStyle()
            
            Text(overview)
                .bodyStyle()
                .lineLimit(nil)
                .foregroundColor(.secondary)
        }
    }
}
