//
//  SearchViewModelTests.swift
//  NeuGelbTestTests
//
//  Created by Marco Maddalena on 25.03.26.
//

import Testing
import Foundation
@testable import NeuGelbTest

@Suite("SearchViewModel Tests")
@MainActor
struct SearchViewModelTests {
    
    @Test("Initial state is empty")
    func testInitialStateIsEmpty() {
        let mockSearchService = MockSearchService()
        let mockImageService = MockImageService()
        let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)
        
        if case .empty = sut.state {
            #expect(true)
        } else {
            Issue.record("Initial state should be .empty")
        }
    }
    
    @Test("Initial pagination values are correct")
    func testInitialPaginationValues() {
        let mockSearchService = MockSearchService()
        let mockImageService = MockImageService()
        let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)
        
        #expect(sut.currentPage == 1)
        #expect(sut.hasMorePages == false)
        #expect(sut.isPaginationLoading == false)
        #expect(sut.searchQuery.isEmpty)
        #expect(sut.searchResults.isEmpty)
    }
    
    // MARK: - Debounce & Filtering Tests
    
     @Test("Debounce waits before executing search")
     func testDebounceWaitsBeforeSearch() async {
        let mockSearchService = MockSearchService()
        mockSearchService.simulateSuccess(with: TestDataBuilder.makeSampleMovieListResponse())
        let mockImageService = MockImageService()
         
        let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)
        
        // Update query but wait less than debounce time (300ms)
        sut.updateSearchQuery("Test")
        try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
        
        // Should not have called API yet
        #expect(mockSearchService.searchMoviesCallCount == 0)
     }
    
      @Test("Search executes after debounce period")
      func testSearchExecutesAfterDebounce() async {
         let mockSearchService = MockSearchService()
         mockSearchService.simulateSuccess(with: TestDataBuilder.makeSampleMovieListResponse())
         let mockImageService = MockImageService()

         let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)
         
         sut.updateSearchQuery("Test")
         try? await Task.sleep(nanoseconds: 400_000_000) // Wait for debounce + margin
         
         #expect(mockSearchService.searchMoviesCallCount == 1)
         #expect(mockSearchService.lastQueryRequested == "Test")
     }
    
      @Test("Duplicate queries only execute once")
      func testDuplicateQueriesExecuteOnce() async {
         let mockSearchService = MockSearchService()
         mockSearchService.simulateSuccess(with: TestDataBuilder.makeSampleMovieListResponse())
         let mockImageService = MockImageService()

         let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)
         
         // Type the same query twice
         sut.updateSearchQuery("Test")
         try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
         sut.updateSearchQuery("Test")
         try? await Task.sleep(nanoseconds: 400_000_000) // Wait for debounce
         
         // Should only call API once due to removeDuplicates
         #expect(mockSearchService.searchMoviesCallCount == 1)
     }
    
    // MARK: - Empty Query Handling Tests
    
      @Test("Empty query clears results")
      func testEmptyQueryClearsResults() async {
         let mockSearchService = MockSearchService()
         mockSearchService.simulateSuccess(with: TestDataBuilder.makeSampleMovieListResponse())
         let mockImageService = MockImageService()

         let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)
         
         // Search first
         sut.updateSearchQuery("Test")
         try? await Task.sleep(nanoseconds: 400_000_000)
         
         #expect(!sut.searchResults.isEmpty)
         
         // Clear search
         sut.updateSearchQuery("")
         try? await Task.sleep(nanoseconds: 100_000_000)
         
         #expect(sut.searchResults.isEmpty)
     }
    
      @Test("Empty query resets state to empty")
      func testEmptyQueryResetsState() async {
         let mockSearchService = MockSearchService()
         mockSearchService.simulateSuccess(with: TestDataBuilder.makeSampleMovieListResponse())
         let mockImageService = MockImageService()

         let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)

         sut.updateSearchQuery("Test")
         try? await Task.sleep(nanoseconds: 400_000_000)
         
         if case .success = sut.state {
             #expect(true)
         } else {
             Issue.record("State should be success after search")
         }

         sut.updateSearchQuery("")
         try? await Task.sleep(nanoseconds: 100_000_000)
         
         if case .empty = sut.state {
             #expect(true)
         } else {
             Issue.record("State should be empty after clearing query")
         }
     }
    
      @Test("Search succeeds and updates state to success")
      func testSearchSucceedsAndUpdatesState() async {
         let mockSearchService = MockSearchService()
         let response = TestDataBuilder.makeSampleMovieListResponse(page: 1, totalPages: 5, results: TestDataBuilder.makeSampleMovieList(count: 10))
         mockSearchService.simulateSuccess(with: response)
         let mockImageService = MockImageService()

         let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)
         
         sut.updateSearchQuery("Test")
         try? await Task.sleep(nanoseconds: 400_000_000)
         
         if case .success(let movies) = sut.state {
             #expect(movies.count == 10)
         } else {
             Issue.record("State should be .success after search")
         }
     }
    
      @Test("Search resets results on new query")
      func testSearchResetsResultsOnNewQuery() async {
         let mockSearchService = MockSearchService()
         let response1 = TestDataBuilder.makeSampleMovieListResponse(results: TestDataBuilder.makeSampleMovieList(count: 5, baseTitle: "Query1"))
         mockSearchService.simulateSuccess(with: response1)
         let mockImageService = MockImageService()
          
         let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)
         
         // First search
         sut.updateSearchQuery("Query1")
         try? await Task.sleep(nanoseconds: 400_000_000)
         
         if case .success(let movies) = sut.state {
             #expect(movies.count == 5)
         }
         
         // Update mock for second search
         let response2 = TestDataBuilder.makeSampleMovieListResponse(results: TestDataBuilder.makeSampleMovieList(count: 3, baseTitle: "Query2"))
         mockSearchService.simulateSuccess(with: response2)
         
         // New search should clear previous results
         sut.updateSearchQuery("Query2")
         try? await Task.sleep(nanoseconds: 400_000_000)
         
         if case .success(let movies) = sut.state {
             #expect(movies.count == 3)
         }
     }
    
      @Test("Search updates hasMorePages correctly")
      func testSearchUpdatesHasMorePages() async {
         let mockSearchService = MockSearchService()
         let response = TestDataBuilder.makeSampleMovieListResponse(page: 1, totalPages: 5)
         mockSearchService.simulateSuccess(with: response)
         let mockImageService = MockImageService()
          
         let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)
         
         sut.updateSearchQuery("Test")
         try? await Task.sleep(nanoseconds: 400_000_000)
         
         #expect(sut.currentPage == 1)
         #expect(sut.hasMorePages == true) // Page 1 of 5 has more pages
     }
    
    // MARK: - Error Handling Tests
    
      @Test("Search failure updates error state")
      func testSearchFailureUpdatesErrorState() async {
         let mockSearchService = MockSearchService()
         mockSearchService.simulateFailure(with: NetworkError.noData)
         let mockImageService = MockImageService()

         let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)
         
         sut.updateSearchQuery("Test")
         try? await Task.sleep(nanoseconds: 400_000_000)
         
         if case .error(let message) = sut.state {
             #expect(!message.isEmpty)
         } else {
             Issue.record("State should be .error after search failure")
         }
     }
    
      @Test("Error state contains error message")
      func testErrorStateContainsMessage() async {
         let mockSearchService = MockSearchService()
         mockSearchService.simulateFailure(with: NetworkError.noData)
         let mockImageService = MockImageService()

         let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)
         
         sut.updateSearchQuery("Test")
         try? await Task.sleep(nanoseconds: 400_000_000)
         
         if case .error(let message) = sut.state {
             #expect(message.contains("No"))
         } else {
             Issue.record("State should be .error")
         }
     }
    
    // MARK: - Pagination Tests
    
      @Test("Load next page appends results")
      func testLoadNextPageAppendsResults() async {
         let mockSearchService = MockSearchService()
         let page1Response = TestDataBuilder.makeSampleMovieListResponse(page: 1, totalPages: 3, results: TestDataBuilder.makeSampleMovieList(count: 5, baseTitle: "Page1"))
         mockSearchService.simulateSuccess(with: page1Response)
         let mockImageService = MockImageService()
          
         let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)

         sut.updateSearchQuery("Test")
         try? await Task.sleep(nanoseconds: 400_000_000)
         
         if case .success(let movies) = sut.state {
             #expect(movies.count == 5)
         }

         let page2Response = TestDataBuilder.makeSampleMovieListResponse(page: 2, totalPages: 3, results: TestDataBuilder.makeSampleMovieList(count: 5, baseTitle: "Page2"))
         mockSearchService.simulateSuccess(with: page2Response)
         
         sut.loadNextPage()
         try? await Task.sleep(nanoseconds: 100_000_000)
         
         if case .success(let movies) = sut.state {
             #expect(movies.count == 10) // 5 from page 1 + 5 from page 2
         } else {
             Issue.record("State should still be success")
         }
     }
    
      @Test("Load next page updates current page")
      func testLoadNextPageUpdatesCurrentPage() async {
         let mockSearchService = MockSearchService()
         let page1Response = TestDataBuilder.makeSampleMovieListResponse(page: 1, totalPages: 3)
         mockSearchService.simulateSuccess(with: page1Response)
         let mockImageService = MockImageService()

         let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)
         
         sut.updateSearchQuery("Test")
         try? await Task.sleep(nanoseconds: 400_000_000)
         
         #expect(sut.currentPage == 1)
         
         let page2Response = TestDataBuilder.makeSampleMovieListResponse(page: 2, totalPages: 3)
         mockSearchService.simulateSuccess(with: page2Response)
         
         sut.loadNextPage()
         try? await Task.sleep(nanoseconds: 100_000_000)
         
         #expect(sut.currentPage == 2)
     }
    
      @Test("Load next page guards when no more pages")
      func testLoadNextPageGuardsWhenNoMorePages() async {
         let mockSearchService = MockSearchService()
         let lastPageResponse = TestDataBuilder.makeSampleMovieListResponse(page: 1, totalPages: 1)
         mockSearchService.simulateSuccess(with: lastPageResponse)
         let mockImageService = MockImageService()

         let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)
         
         sut.updateSearchQuery("Test")
         try? await Task.sleep(nanoseconds: 400_000_000)
         
         #expect(sut.hasMorePages == false)
         
         let callCountBefore = mockSearchService.searchMoviesCallCount
         sut.loadNextPage()

         #expect(mockSearchService.searchMoviesCallCount == callCountBefore)
     }
    
     @Test("shouldLoadNextPage detects last movie")
     func testShouldLoadNextPageDetectsLastMovie() {
         let mockSearchService = MockSearchService()
         let mockImageService = MockImageService()
         
         let movies = TestDataBuilder.makeSampleMovieList(count: 3)
         let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)
         
         sut.searchResults = movies
         sut.hasMorePages = true
         
         #expect(sut.shouldLoadNextPage(for: movies.last!))
         #expect(!sut.shouldLoadNextPage(for: movies.first!))
     }
    
     @Test("Select movie sets selected movie ID")
     func testSelectMovieSetsMovieId() {
         let mockSearchService = MockSearchService()
         let mockImageService = MockImageService()
         
         let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)
         let testMovie = TestDataBuilder.makeSampleMovie(tmdbId: 12345)
         
         sut.selectMovie(testMovie.tmdbId)
         
         #expect(sut.selectedMovieId == 12345)
     }
    
     @Test("Clear selection resets movie ID")
     func testClearSelectionResetsMovieId() {
         let mockSearchService = MockSearchService()
         let mockImageService = MockImageService()
         
         let sut = SearchViewModel(searchService: mockSearchService, imageService: mockImageService)
         
         sut.selectMovie(12345)
         #expect(sut.selectedMovieId == 12345)
         
         sut.clearSelection()
         #expect(sut.selectedMovieId == nil)
     }
}
