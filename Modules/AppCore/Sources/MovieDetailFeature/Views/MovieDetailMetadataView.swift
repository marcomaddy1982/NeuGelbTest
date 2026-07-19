//
//  MovieDetailMetadataView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import DesignSystem
import SwiftUI

struct MovieDetailMetadataView: View {
    let releaseDate: String
    let runtime: String
    
    var body: some View {
        VStack(spacing: 8) {
            MetadataRowView(label: "movieDetail.releaseDate", value: releaseDate)
            MetadataRowView(label: "movieDetail.runtime", value: runtime)
        }
    }
}
