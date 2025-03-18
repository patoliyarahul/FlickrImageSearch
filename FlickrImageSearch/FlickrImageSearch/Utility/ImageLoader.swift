//
//  ImageLoader.swift
//  FlickrImageSearch
//
//

import UIKit

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    func loadImage(from urlString: String) {
        isLoading = true
        Task {
            do {
                let loadedImage = try await ImageCacheManager.shared.loadImage(from: urlString)
                await MainActor.run {
                    self.image = loadedImage
                }
            } catch {
                print("Failed to load image: \(error)")
            }
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}
