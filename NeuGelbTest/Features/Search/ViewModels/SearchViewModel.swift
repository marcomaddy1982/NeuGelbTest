//
//  SearchViewModel.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 24.03.26.
//

import Foundation
import Combine

enum SearchViewState: Sendable {
    case empty
    case loading
    case success([Movie])
    case error(String)
}

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var searchResults: [Movie] = []
    @Published var state: SearchViewState = .empty
    @Published var selectedMovieId: Int? = nil

    @Published var currentPage: Int = 1
    @Published var hasMorePages: Bool = false
    @Published var isPaginationLoading: Bool = false

    private let searchService: SearchServiceProtocol
    let imageService: ImageServiceProtocol

    nonisolated(unsafe) private var cancellables: Set<AnyCancellable> = []
    
    init(searchService: SearchServiceProtocol, imageService: ImageServiceProtocol) {
        self.searchService = searchService
        self.imageService = imageService
        setupSearchPipeline()
    }
    
    // MARK: - Public Methods

    func performSearch(query: String) {
        isPaginationLoading = false

        currentPage = 1
        searchResults = []
        hasMorePages = false
        
        state = .loading
        
        Task {
            await executeSearch(query: query, page: 1)
        }
    }

    func loadNextPage() {
        guard !isPaginationLoading, hasMorePages, currentPage < 1000 else { return }
        
        isPaginationLoading = true
        let nextPage = currentPage + 1
        
        Task {
            await executeSearch(
                query: searchQuery,
                page: nextPage,
                isPagination: true
            )
        }
    }

    func selectMovie(_ movieId: Int) {
        selectedMovieId = movieId
    }

    func clearSelection() {
        selectedMovieId = nil
    }

    func updateSearchQuery(_ query: String) {
        searchQuery = query
    }

    func shouldLoadNextPage(for movie: Movie) -> Bool {
        guard let lastMovie = searchResults.last else { return false }
        return movie.id == lastMovie.id && hasMorePages
    }
    
    // MARK: - Private Methods

    private func setupSearchPipeline() {
        // Pipeline 1: Handle valid searches (3+ characters)
        $searchQuery
            .debounce(for: .milliseconds(300),
                      scheduler: DispatchQueue.global(qos: .userInitiated))
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)

        // Pipeline 2: Handle empty queries (user taps X button)
        $searchQuery
            .filter { $0.isEmpty }
            .sink { [weak self] _ in
                self?.clearSearchState()
            }
            .store(in: &cancellables)
    }

    private func executeSearch(query: String, page: Int, isPagination: Bool = false) async {
        do {
            let response = try await searchService.searchMovies(query: query, page: page)
            
            if isPagination {
                searchResults.append(contentsOf: response.results)
                isPaginationLoading = false
            } else {
                searchResults = response.results
            }
            
            currentPage = page
            hasMorePages = page < response.totalPages
            state = .success(searchResults)
        } catch {
            let errorMessage = error.localizedDescription
            state = .error(errorMessage)
            isPaginationLoading = false
        }
    }

    private func clearSearchState() {
        searchResults = []
        currentPage = 1
        hasMorePages = false
        isPaginationLoading = false
        state = .empty
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
