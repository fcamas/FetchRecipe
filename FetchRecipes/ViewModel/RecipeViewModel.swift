//
//  RecipeViewModel.swift
//  FetchRecipes
//
//  Created by Fredy on 12/9/24.
//

import SwiftUI

// Enum for different API endpoints
enum EndPoint: CaseIterable {
    case allData, malformedData, emptyData

    var label: String {
        switch self {
        case .allData: return "All Recipes"
        case .malformedData: return "Malformed Data"
        case .emptyData: return "Empty Data"
        }
    }

    var url: URL {
        switch self {
        case .allData:
            return URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
        case .malformedData:
            return URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!
        case .emptyData:
            return URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!
        }
    }
}

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading = false

    private var currentEndpoint: EndPoint = .allData
    private var currentTask: Task<Void, Never>? = nil
    private let networkService: NetworkService

    // Injecting networkService dependency. Default is URLSessionNetworkService.
    init(networkService: NetworkService = URLSessionNetworkService()) {
        self.networkService = networkService
    }

    func fetchRecipes() async {
        // Cancel any ongoing fetch task before starting a new one.
        currentTask?.cancel()
        
        // Show loading indicator.
        isLoading = true
        defer { isLoading = false }
        
        // Starting a new task to fetch recipes.
        currentTask = Task {
            do {
                let data = try await networkService.fetchData(from: currentEndpoint.url)
                let decodedData = try JSONDecoder().decode(RecipesResponse.self, from: data)
                recipes = decodedData.recipes
                errorMessage = nil
            } catch {
                // Handle error by updating errorMessage and clearing recipes.
                recipes = []
                errorMessage = error.localizedDescription
            }
        }
    }

    // Update the current endpoint and trigger data fetching for the new endpoint.
    func updateEndpoint(to endpoint: EndPoint) {
        currentEndpoint = endpoint
        Task {
            await fetchRecipes()  
        }
    }
}
