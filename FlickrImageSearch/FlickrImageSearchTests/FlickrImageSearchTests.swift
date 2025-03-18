//
//  FlickrImageSearchTests.swift
//  FlickrImageSearchTests
//
//

import XCTest
@testable import FlickrImageSearch

class PhotoSearchViewModelTests: XCTestCase {

    var viewModel: PhotoSearchViewModel!

    override func setUp() {
        super.setUp()
        Task { @MainActor in
            viewModel = PhotoSearchViewModel()
        }
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testSearchPhotos() async {
        let mockPhotos = [
            Photo(title: "Test Image", link: "https://example.com/image.jpg", media: Media(m: "https://example.com/image.jpg"), description: "Description", published: Date(), author: "Author")
        ]
        
        let mockNetworkManager = MockNetworkManager(photos: mockPhotos)
        let viewModel = PhotoSearchViewModel(networkManager: mockNetworkManager)
        
        await viewModel.searchPhotos(with: "test")
        
        XCTAssertEqual(viewModel.photos.count, 1)
        XCTAssertEqual(viewModel.photos.first?.title, "Test Image")
    }
    
    func testSearchPhotosHandlesError() async {
        class FailingNetworkManager: NetworkManagerProtocol {
            func fetchPhotos(for tags: String) async throws -> [Photo] {
                throw URLError(.badServerResponse)
            }
        }
        
        let failingNetworkManager = FailingNetworkManager()
        let viewModel = PhotoSearchViewModel(networkManager: failingNetworkManager)
        
        await viewModel.searchPhotos(with: "test")
        
        XCTAssertTrue(viewModel.photos.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.errorMessage!.isEmpty)
    }
}
