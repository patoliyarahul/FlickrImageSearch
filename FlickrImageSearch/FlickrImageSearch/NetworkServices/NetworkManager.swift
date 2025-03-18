//
//  NetworkManager.swift
//  FlickrImageSearch
//
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchPhotos(for tags: String) async throws -> [Photo]
}

// MARK: - Network Error
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

// MARK: - NetworkManager
class NetworkManager: NetworkManagerProtocol {
    static var shared = NetworkManager()
    
    private init() {}
    
    func fetchPhotos(for tags: String) async throws -> [Photo] {
        let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(tags)"
        
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let photoFeed = try decoder.decode(PhotoFeed.self, from: data)
            return photoFeed.items
        } catch {
            throw NetworkError.invalidData
        }
    }
}
