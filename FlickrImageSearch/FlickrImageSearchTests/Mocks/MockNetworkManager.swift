//
//  MockNetworkManager.swift
//  FlickrImageSearchTests
//
//

import Foundation
@testable import FlickrImageSearch

class MockNetworkManager: NetworkManagerProtocol {
    private let photos: [Photo]
    
    init(photos: [Photo]) {
        self.photos = photos
    }
    
    func fetchPhotos(for tags: String) async throws -> [Photo] {
        return photos
    }
}
