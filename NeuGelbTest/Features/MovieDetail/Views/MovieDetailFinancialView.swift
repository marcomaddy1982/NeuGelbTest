//
//  MovieDetailFinancialView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import SwiftUI

struct MovieDetailFinancialView: View {
    let budget: String
    let revenue: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Financial")
                .headlineStyle()
            
            VStack(spacing: 8) {
                MetadataRowView(label: "Budget", value: budget)
                MetadataRowView(label: "Revenue", value: revenue)
            }
        }
    }
}
