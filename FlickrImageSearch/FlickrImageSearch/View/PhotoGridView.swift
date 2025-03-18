//
//  PhotoGridView.swift
//  FlickrImageSearch
//
//

import SwiftUI

struct PhotoGridView: View {
    @StateObject var viewModel = PhotoSearchViewModel()
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search...", text: $viewModel.searchText)
                    .accessibilityIdentifier("SearchField")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.photos) { photo in
                            NavigationLink(destination: PhotoDetailView(photo: photo)) {
                                PhotoGridItemView(photo: photo)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .accessibilityIdentifier("GridView")
                }
            }
            .navigationTitle("Flickr Search")
        }
    }
}
