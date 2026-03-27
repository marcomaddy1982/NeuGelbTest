//
//  MovieDetailAttributesView.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import SwiftUI

struct MovieDetailAttributesView: View {
    let hasGenres: Bool
    let genres: [Genre]
    let hasProductionCompanies: Bool
    let productionCompanies: [ProductionCompany]
    let hasProductionCountries: Bool
    let productionCountries: [ProductionCountry]
    let hasSpokenLanguages: Bool
    let spokenLanguages: [SpokenLanguage]
    
    var body: some View {
        // Genres
        if hasGenres {
            VStack(alignment: .leading, spacing: 8) {
                Text("Genres")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(genres, id: \.id) { genre in
                        HStack {
                            Text(genre.name)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(.systemGray5))
                                .cornerRadius(16)
                            Spacer()
                        }
                    }
                }
            }
        }
        
        // Production Companies
        if hasProductionCompanies {
            VStack(alignment: .leading, spacing: 8) {
                Text("Production Companies")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(productionCompanies, id: \.id) { company in
                        Text(company.name)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        
        // Production Countries
        if hasProductionCountries {
            VStack(alignment: .leading, spacing: 8) {
                Text("Countries")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(productionCountries, id: \.id) { country in
                        HStack {
                            Text(country.name)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(.systemGray5))
                                .cornerRadius(16)
                            Spacer()
                        }
                    }
                }
            }
        }
        
        // Spoken Languages
        if hasSpokenLanguages {
            VStack(alignment: .leading, spacing: 8) {
                Text("Languages")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(spokenLanguages, id: \.id) { language in
                        HStack {
                            Text(language.englishName ?? language.name)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(.systemGray5))
                                .cornerRadius(16)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}
