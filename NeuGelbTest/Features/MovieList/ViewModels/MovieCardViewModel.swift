//
//  MovieCardViewModel.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 23.03.26.
//

import Foundation
import Combine
import SwiftUI
import os

enum ImageLoadingState {
    case idle
    case loading
    case success(Image)
    case error(String)
}

@MainActor
final class MovieCardViewModel: ObservableObject {
    let movie: Movie
    private let imageService: any ImageServiceProtocol
    
    @Published var imageState: ImageLoadingState = .idle
    
    var title: String { movie.title }
    var releaseDate: String {
        guard let dateString = movie.releaseDate, !dateString.isEmpty else {
            return "To Be Announced"
        }
        return dateString.toMonthDayYearString() ?? "To Be Announced"
    }
    var voteAverage: String { String(format: "%.1f", movie.voteAverage) }
    var posterPath: String? { movie.posterPath }
    
    private var imageLoadTask: Task<Void, Never>?
    
    init(movie: Movie, imageService: any ImageServiceProtocol) {
        self.movie = movie
        self.imageService = imageService
    }
    
    func loadImage() {
        imageLoadTask?.cancel()
        
        guard let posterPath else {
            imageState = .idle
            return
        }
        
        imageLoadTask = Task {
            imageState = .loading
            
            if let image = await imageService.loadImage(from: posterPath) {
                if !Task.isCancelled {
                    imageState = .success(image)
                }
            } else {
                if !Task.isCancelled {
                    imageState = .error("Failed to load poster")
                }
            }
        }
    }
    
    func cancelImageLoad() {
        imageLoadTask?.cancel()
        imageLoadTask = nil
    }
    
    deinit {
        imageLoadTask?.cancel()
    }
}
