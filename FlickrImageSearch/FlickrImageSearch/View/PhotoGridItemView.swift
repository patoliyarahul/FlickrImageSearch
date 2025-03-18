//
//  PhotoGridItemView.swift
//  FlickrImageSearch
//
//

import SwiftUI

struct PhotoGridItemView: View {
    let photo: Photo
    
    @StateObject private var imageLoader = ImageLoader()
    
    var body: some View {
        ZStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else if imageLoader.isLoading {
                ProgressView()
                    .frame(width: 120, height: 120)
            } else {
                Color.gray.opacity(0.2)
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .onAppear {
            imageLoader.loadImage(from: photo.media.m)
        }
    }
}
