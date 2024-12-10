//
//  ImageCache.swift
//  FetchRecipes
//
//  Created by Fredy on 12/9/24.
//

import UIKit

/// A singleton class responsible for caching images in memory and on disk to optimize network requests.
class ImageCache {
    private var cache: [URL: UIImage] = [:]
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let cacheQueue = DispatchQueue(label: "com.fetchrecipes.imagecache")

    static let shared = ImageCache()

    private init() {
        let directory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = directory.appendingPathComponent("ImageCache")

        // Create directory if it doesn't exist
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }

    func getImage(for url: URL) -> UIImage? {
        var fetchedImage: UIImage?
        cacheQueue.sync {
            fetchedImage = cache[url] ?? loadImageFromDisk(for: url)
        }
        return fetchedImage
    }

    func saveImage(_ image: UIImage, for url: URL) {
        cacheQueue.async {
            self.cache[url] = image
            self.saveImageToDisk(image, for: url)
        }
    }

    private func loadImageFromDisk(for url: URL) -> UIImage? {
        let filePath = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        if let data = try? Data(contentsOf: filePath), let image = UIImage(data: data) {
            cache[url] = image
            return image
        }
        return nil
    }

    private func saveImageToDisk(_ image: UIImage, for url: URL) {
        let filePath = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        if let data = image.pngData() {
            try? data.write(to: filePath)
        }
    }
}
