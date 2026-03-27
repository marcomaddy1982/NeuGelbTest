//
//  MovieDetailMetadataView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import SwiftUI

struct MovieDetailMetadataView: View {
    let releaseDate: String
    let runtime: String
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Release Date")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(releaseDate)
                    .font(.body)
            }
            
            Divider()
                .frame(height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Runtime")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(runtime)
                    .font(.body)
            }
            
            Spacer()
        }
    }
}
