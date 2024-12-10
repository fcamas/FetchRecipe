//
//  RecipeViewModelTests.swift
//  FetchRecipes
//
//  Created by Fredy on 12/10/24.
//

import XCTest
@testable import FetchRecipes

class RecipeViewModelTests: XCTestCase {
    
    var viewModel: RecipeViewModel!
    var mockURLProtocol: MockURLProtocol!

    override func setUp() async throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)

        let networkService = URLSessionNetworkService(session: session)
        viewModel = await RecipeViewModel(networkService: networkService)
        mockURLProtocol = MockURLProtocol()
        MockURLProtocol.mockData = nil
        MockURLProtocol.mockError = nil
        MockURLProtocol.mockResponse = nil
    }

    override func tearDown() {
        viewModel = nil
        mockURLProtocol = nil
        super.tearDown()
    }

    // Test Case 1: Fetch Recipes with Mock Data (Valid URL)
    @MainActor
    func testFetchRecipesWithValidURL() async throws {
        // Prepare mock recipe data
        let mockRecipeData = """
        {
            "recipes": [
                {
                    "cuisine": "Italian",
                    "name": "Spaghetti Carbonara",
                    "photo_url_small": "https://example.com/small.jpg",
                    "photo_url_large": "https://example.com/large.jpg",
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "source_url": "https://example.com/recipe",
                    "youtube_url": "https://youtube.com/watch?v=somevideo"
                }
            ]
        }
        """.data(using: .utf8)!

        MockURLProtocol.mockData = mockRecipeData
        MockURLProtocol.mockResponse = HTTPURLResponse(
            url: EndPoint.allData.url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // Perform the async fetch
        await viewModel.fetchRecipes()
        
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Assert main actor-isolated properties
        XCTAssertEqual(viewModel.recipes.count, 1, "Expected one recipe")
        XCTAssertEqual(viewModel.recipes.first?.name, "Spaghetti Carbonara", "Expected recipe name to be 'Spaghetti Carbonara'")
    }

    // Test Case 2: Fetch Recipes with Mock Malformed Data (Invalid URL)
    @MainActor
    func testFetchRecipesWithMalformedData() async throws {
        // Simulate a bad response (server error)
        MockURLProtocol.mockError = URLError(.badServerResponse)
        MockURLProtocol.mockResponse = HTTPURLResponse(
            url: EndPoint.malformedData.url,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        
        // Perform the async fetch
        await viewModel.fetchRecipes()
        
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Assert error message and recipes count
        XCTAssertNotNil(viewModel.errorMessage, "Expected an error message for bad server response")
        XCTAssertTrue(viewModel.errorMessage?.contains("The operation couldn’t be completed") ?? false, "Error message doesn't match expected output")
        XCTAssertEqual(viewModel.recipes.count, 0, "Expected no recipes on error")
    }

    // Test Case 3: Fetch Recipes with Empty Data
    @MainActor
    func testFetchRecipesWithEmptyData() async throws {
        // Prepare empty mock recipe data
        let mockEmptyData = """
        {
            "recipes": []
        }
        """.data(using: .utf8)!

        MockURLProtocol.mockData = mockEmptyData
        MockURLProtocol.mockResponse = HTTPURLResponse(
            url: EndPoint.emptyData.url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // Perform the async fetch
        await viewModel.fetchRecipes()
        
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Assert that no recipes were returned
        XCTAssertEqual(viewModel.recipes.count, 0, "Expected no recipes from empty data")
    }
}
