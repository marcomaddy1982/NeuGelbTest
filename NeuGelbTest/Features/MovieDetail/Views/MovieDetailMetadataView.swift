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
        VStack(spacing: 8) {
            MetadataRowView(label: "Release Date", value: releaseDate)
            MetadataRowView(label: "Runtime", value: runtime)
        }
    }
}
