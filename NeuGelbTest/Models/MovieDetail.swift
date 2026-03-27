//
//  MovieDetail.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import Foundation

nonisolated struct MovieDetail: Codable, Sendable {
    let tmdbId: Int
    let title: String
    let overview: String?
    let backdropPath: String?
    let posterPath: String?
    let voteAverage: Double
    let releaseDate: String?
    let runtime: Int?
    let tagline: String?
    let budget: Int
    let revenue: Int
    let genres: [Genre]
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let spokenLanguages: [SpokenLanguage]
    
    enum CodingKeys: String, CodingKey {
        case title, overview, tagline, budget, revenue, genres, runtime
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case tmdbId = "id"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case spokenLanguages = "spoken_languages"
    }
}

// MARK: - Supporting Models

nonisolated struct Genre: Codable, Sendable, Identifiable {
    let id: Int
    let name: String
}

nonisolated struct ProductionCompany: Codable, Sendable, Identifiable {
    let id: Int
    let name: String
}

nonisolated struct ProductionCountry: Codable, Sendable, Identifiable {
    let iso3166_1: String
    let name: String
    
    var id: String { iso3166_1 }
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

nonisolated struct SpokenLanguage: Codable, Sendable, Identifiable {
    let iso639_1: String
    let name: String
    let englishName: String?
    
    var id: String { iso639_1 }
    
    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case name
        case englishName = "english_name"
    }
}
