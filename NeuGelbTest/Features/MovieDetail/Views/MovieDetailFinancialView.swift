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
                .font(.headline)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Budget")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(budget)
                        .font(.body)
                }
                
                Divider()
                    .frame(height: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Revenue")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(revenue)
                        .font(.body)
                }
                
                Spacer()
            }
        }
    }
}
