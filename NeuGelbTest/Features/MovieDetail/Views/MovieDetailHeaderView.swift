//
//  MovieDetailHeaderView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import SwiftUI

struct MovieDetailHeaderView: View {
    let title: String
    let voteAverage: String
    let tagline: String?
    let hasTagline: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .lineLimit(3)
            
            HStack(spacing: 8) {
                Label(voteAverage, systemImage: "star.fill")
                    .font(.headline)
                    .foregroundColor(.orange)
                
                Spacer()
            }
        }
        
        if hasTagline, let tagline {
            Text(tagline)
                .font(.system(.body, design: .default))
                .italic()
                .foregroundColor(.secondary)
        }
    }
}
