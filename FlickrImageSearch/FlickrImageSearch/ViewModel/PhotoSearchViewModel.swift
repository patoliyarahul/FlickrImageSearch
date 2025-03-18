//
//  PhotoSearchViewModel.swift
//  FlickrImageSearch
//
//

import Foundation
import Combine

class PhotoSearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var photos: [Photo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
        setupSearchListener()
    }

    private func setupSearchListener() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main) // Debounce to avoid frequent API calls
            .removeDuplicates()
            .sink { [weak self] text in
                Task {
                    await self?.searchPhotos(with: text)
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func searchPhotos(with tags: String) async {
        guard !tags.isEmpty else {
            photos = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedPhotos = try await networkManager.fetchPhotos(for: tags)
            photos = fetchedPhotos
        } catch {
            handleNetworkError(error)
        }
        
        isLoading = false
    }
    
    private func handleNetworkError(_ error: Error) {
        switch error {
        case NetworkError.invalidURL:
            errorMessage = "Invalid URL"
        case NetworkError.invalidResponse:
            errorMessage = "Invalid server response"
        case NetworkError.invalidData:
            errorMessage = "Failed to parse data"
        default:
            errorMessage = "An unknown error occurred"
        }
    }
}
