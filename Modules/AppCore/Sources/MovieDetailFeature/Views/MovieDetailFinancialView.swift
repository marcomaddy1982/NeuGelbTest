//
//  MovieDetailFinancialView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import DesignSystem
import SwiftUI

struct MovieDetailFinancialView: View {
    let budget: String
    let revenue: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("movieDetail.financial")
                .headlineStyle()
            
            VStack(spacing: 8) {
                MetadataRowView(label: "movieDetail.budget", value: budget)
                MetadataRowView(label: "movieDetail.revenue", value: revenue)
            }
        }
    }
}
