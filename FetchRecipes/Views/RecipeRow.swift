//
//  RecipeRow.swift
//  FetchRecipes
//
//  Created by Fredy on 12/10/24.
//

import SwiftUI
import UIKit

// Row to display each recipe
struct RecipeRow: View {
    let recipe: Recipe
    @State private var cachedImage: UIImage?

    var body: some View {
        HStack {
            if let url = recipe.photoURLSmall {
                // Use AsyncImage to fetch the image from the network
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView().frame(width: 60, height: 60)
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .onAppear {
                                // Save the image to cache once it appears
                                if let uiImage = image.asUIImage() {
                                    cachedImage = uiImage
                                    saveImageToCache(image: uiImage, for: url)
                                }
                            }
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 60, height: 60)
                    @unknown default:
                        EmptyView()
                    }
                }
                .onAppear {
                    // Check cache before displaying
                    if let cachedImage = ImageCache.shared.getImage(for: url) {
                        self.cachedImage = cachedImage
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 60, height: 60)
            }

            VStack(alignment: .leading) {
                Text(recipe.name).font(.headline)
                Text(recipe.cuisine).font(.subheadline).foregroundColor(.secondary)
            }
        }
    }

    // Save image asynchronously to cache
    private func saveImageToCache(image: UIImage, for url: URL) {
        DispatchQueue.global(qos: .background).async {
            ImageCache.shared.saveImage(image, for: url)
        }
    }
}
