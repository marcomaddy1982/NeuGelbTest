//
//  MovieListViewModelTests.swift
//  NeuGelbTestTests
//
//  Created by Marco Maddalena on 23.03.26.
//

import Testing
import Foundation
@testable import NeuGelbTest

@Suite("MovieListViewModel Tests")
@MainActor
struct MovieListViewModelTests {
    
    @Test("Initial state is loading with default pagination values")
    func testInitialState() {
        let mockMovieService = MockMovieService()
        let mockImageService = MockImageService()
        let sut = MovieListViewModel(movieService: mockMovieService, imageService: mockImageService)

        if case .loading = sut.state {
            #expect(true)
        } else {
            Issue.record("Initial state should be .loading")
        }
        #expect(sut.currentPage == 1)
        #expect(sut.hasMorePages == true)
        #expect(sut.isPaginationLoading == false)
    }
    
    @Test("loadMovies succeeds and updates state to success")
    func testLoadMoviesSuccess() async {
        let mockMovieService = MockMovieService()
        let mockImageService = MockImageService()
        let sampleResponse = TestDataBuilder.makeSampleDiscoverResponse(page: 1, totalPages: 10)
        mockMovieService.simulateSuccess(with: sampleResponse)
        
        let sut = MovieListViewModel(movieService: mockMovieService, imageService: mockImageService)

        await sut.loadMovies()

        if case .success(let movies) = sut.state {
            #expect(movies.count == 5) // Default sample has 5 movies
        } else {
            Issue.record("State should be .success after loading")
        }
        #expect(sut.currentPage == 1)
        #expect(sut.hasMorePages == true)
        #expect(mockMovieService.fetchMoviesCallCount == 1)
    }
    
    @Test("loadMovies handles errors and updates state to error")
    func testLoadMoviesError() async {
        let mockMovieService = MockMovieService()
        let mockImageService = MockImageService()
        mockMovieService.simulateFailure(with: NetworkError.noData)
        
        let sut = MovieListViewModel(movieService: mockMovieService, imageService: mockImageService)

        await sut.loadMovies()

        if case .error(let message) = sut.state {
            #expect(message.contains("Failed to load movies"))
        } else {
            Issue.record("State should be .error after failure")
        }
    }
    
    @Test("loadNextPage appends movies to existing list")
    func testLoadNextPageAppendMovies() async {
        let mockMovieService = MockMovieService()
        let mockImageService = MockImageService()
        let page1Response = TestDataBuilder.makeSampleDiscoverResponse(page: 1, totalPages: 3, results: TestDataBuilder.makeSampleMovieList(count: 5, baseTitle: "Page1"))
        mockMovieService.simulateSuccess(with: page1Response)
        
        let sut = MovieListViewModel(movieService: mockMovieService, imageService: mockImageService)

        await sut.loadMovies()

        let page2Response = TestDataBuilder.makeSampleDiscoverResponse(page: 2, totalPages: 3, results: TestDataBuilder.makeSampleMovieList(count: 5, baseTitle: "Page2"))
        mockMovieService.simulateSuccess(with: page2Response)

        await sut.loadNextPage()

        if case .success(let movies) = sut.state {
            #expect(movies.count == 10) // 5 from page 1 + 5 from page 2
        } else {
            Issue.record("State should contain success with appended movies")
        }
        #expect(sut.currentPage == 2)
        #expect(mockMovieService.fetchMoviesCallCount == 2)
    }
    
    @Test("loadNextPage updates pagination info")
    func testLoadNextPageUpdatesPaginationInfo() async {
        let mockMovieService = MockMovieService()
        let mockImageService = MockImageService()
        let page1Response = TestDataBuilder.makeSampleDiscoverResponse(page: 1, totalPages: 3)
        mockMovieService.simulateSuccess(with: page1Response)
        
        let sut = MovieListViewModel(movieService: mockMovieService, imageService: mockImageService)
        await sut.loadMovies()

        let lastPageResponse = TestDataBuilder.makeSampleDiscoverResponse(page: 3, totalPages: 3)
        mockMovieService.simulateSuccess(with: lastPageResponse)

        await sut.loadNextPage()
        await sut.loadNextPage()

        #expect(sut.currentPage == 3)
        #expect(sut.hasMorePages == false) // No more pages after page 3 of 3
    }
    
    @Test("loadNextPage guards when state is not success")
    func testLoadNextPageGuardsWhenNotSuccess() async {
        let mockMovieService = MockMovieService()
        let mockImageService = MockImageService()
        mockMovieService.simulateFailure(with: NetworkError.noData)
        
        let sut = MovieListViewModel(movieService: mockMovieService, imageService: mockImageService)
        await sut.loadMovies() // Will result in .error state

        await sut.loadNextPage()

        #expect(mockMovieService.fetchMoviesCallCount == 1) // Only from loadMovies
    }
    
    @Test("loadNextPage guards when no more pages available")
    func testLoadNextPageGuardsWhenNoMorePages() async {
        let mockMovieService = MockMovieService()
        let mockImageService = MockImageService()
        let lastPageResponse = TestDataBuilder.makeSampleDiscoverResponse(page: 1, totalPages: 1)
        mockMovieService.simulateSuccess(with: lastPageResponse)
        
        let sut = MovieListViewModel(movieService: mockMovieService, imageService: mockImageService)
        await sut.loadMovies() // Loads single page

        await sut.loadNextPage()

        #expect(mockMovieService.fetchMoviesCallCount == 1) // Only from loadMovies
        #expect(sut.hasMorePages == false)
    }
    
    @Test("loadNextPage guards when already loading")
    func testLoadNextPageGuardsWhenAlreadyLoading() async {
        let mockMovieService = MockMovieService()
        let mockImageService = MockImageService()
        let page1Response = TestDataBuilder.makeSampleDiscoverResponse(page: 1, totalPages: 2)
        mockMovieService.simulateSuccess(with: page1Response)
        
        let sut = MovieListViewModel(movieService: mockMovieService, imageService: mockImageService)
        await sut.loadMovies()

        sut.isPaginationLoading = true
        await sut.loadNextPage()

        #expect(mockMovieService.fetchMoviesCallCount == 1) // Only from initial loadMovies
    }
    
    @Test("shouldLoadNextPage returns true for last movie with more pages")
    func testShouldLoadNextPageDetectsLastMovie() {
        let mockMovieService = MockMovieService()
        let mockImageService = MockImageService()
        
        let movies = TestDataBuilder.makeSampleMovieList(count: 3)
        let sut = MovieListViewModel(movieService: mockMovieService, imageService: mockImageService)

        sut.state = .success(movies)
        sut.hasMorePages = true
        sut.isPaginationLoading = false

        #expect(sut.shouldLoadNextPage(for: movies.last!))

        #expect(!sut.shouldLoadNextPage(for: movies.first!))
    }
    
    @Test("shouldLoadNextPage returns false when no more pages")
    func testShouldLoadNextPageFalseWhenNoMorePages() {
        let mockMovieService = MockMovieService()
        let mockImageService = MockImageService()
        
        let movies = TestDataBuilder.makeSampleMovieList(count: 2)
        let sut = MovieListViewModel(movieService: mockMovieService, imageService: mockImageService)
        
        sut.state = .success(movies)
        sut.hasMorePages = false // No more pages
        sut.isPaginationLoading = false

        #expect(!sut.shouldLoadNextPage(for: movies.last!))
    }
    
    @Test("shouldLoadNextPage returns false when pagination is loading")
    func testShouldLoadNextPageFalseWhenLoading() {
        let mockMovieService = MockMovieService()
        let mockImageService = MockImageService()
        
        let movies = TestDataBuilder.makeSampleMovieList(count: 2)
        let sut = MovieListViewModel(movieService: mockMovieService, imageService: mockImageService)
        
        sut.state = .success(movies)
        sut.hasMorePages = true
        sut.isPaginationLoading = true

        #expect(!sut.shouldLoadNextPage(for: movies.last!))
    }
}
