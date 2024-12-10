//
//  RecipeListView.swift
//  FetchRecipes
//
//  Created by Fredy on 12/9/24.
//

import SwiftUI

/// A view that displays a list of recipes and provides functionality for refreshing and selecting different endpoints.
struct RecipeListView: View {
    /// The view model responsible for fetching and storing recipes.
    @StateObject private var viewModel = RecipeViewModel()
    
    /// The selected endpoint for fetching data (e.g., different categories of recipes).
    @State private var selectedEndpoint: EndPoint = .allData

    var body: some View {
        NavigationView {
            Group {
                // Show loading indicator while recipes are being fetched
                if viewModel.isLoading {
                    ProgressView("Loading recipes...")
                }
                // Display an error message if there was an issue fetching recipes
                else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)").multilineTextAlignment(.center)
                }
                // Show a message if no recipes are available
                else if viewModel.recipes.isEmpty {
                    Text("No recipes available").multilineTextAlignment(.center)
                }
                // Display the list of recipes when they are successfully loaded
                else {
                    List(viewModel.recipes) { recipe in
                        RecipeRow(recipe: recipe)
                    }
                    .refreshable {
                        // Trigger reload on pull-to-refresh action
                        await viewModel.fetchRecipes()
                    }
                }
            }
            .navigationTitle("Recipes") 
            .toolbar {
                // Add a toolbar item for selecting an endpoint
                ToolbarItem(placement: .bottomBar) {
                    Picker("Endpoints", selection: $selectedEndpoint) {
                        ForEach(EndPoint.allCases, id: \.self) { endpoint in
                            Text(endpoint.label)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedEndpoint) { _, newEndpoint in
                        // Update the selected endpoint and fetch new data when the selection changes
                        viewModel.updateEndpoint(to: newEndpoint)
                    }
                }
            }
            .onChange(of: selectedEndpoint) { _, newEndpoint in
                Task {
                    // Fetch recipes based on the new endpoint
                    viewModel.updateEndpoint(to: newEndpoint)
                }
            }
            .task {
                // Fetch the initial set of recipes when the view is first loaded
                await viewModel.fetchRecipes()
            }
        }
    }
}
