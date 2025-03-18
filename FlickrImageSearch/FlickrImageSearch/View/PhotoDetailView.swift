//
//  PhotoDetailView.swift
//  FlickrImageSearch
//
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: Photo
    
    @StateObject private var imageLoader = ImageLoader()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let image = imageLoader.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 5)
                        .transition(.opacity)
                        .modifier(AnimateImageTransition()) // Custom animation modifier
                } else if imageLoader.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Color.gray.opacity(0.2)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                
                Text(photo.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                if let author = extractAuthorName(from: photo.author) {
                    Text("By \(author)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                                
                if let publishedDate = formatDate(photo.published) {
                    Text("Published on \(publishedDate)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                if let description = extractDescription(from: photo.description) {
                    Text(description)
                        .font(.body)
                        .padding(.top, 4)
                }
                
                Spacer()
                
                // Share Button
                Button(action: shareImage) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 5)
                }
                .padding(.top, 16)
            }
            .padding()
        }
        .navigationTitle("Photo Detail")
        .onAppear {
            imageLoader.loadImage(from: photo.media.m)
        }
    }
        
    // Extract Author Name
    private func extractAuthorName(from rawString: String) -> String? {
        let pattern = "\"(.*?)\""
        if let range = rawString.range(of: pattern, options: .regularExpression) {
            return String(rawString[range].dropFirst().dropLast())
        }
        return nil
    }
    
    // Extract Description (strip HTML tags)
    private func extractDescription(from rawString: String) -> String? {
        let stripped = rawString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return stripped.isEmpty ? nil : stripped
    }
    
    // Format Date
    private func formatDate(_ date: Date) -> String? {
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        return displayFormatter.string(from: date)
    }

    // Share the Image
    private func shareImage() {
        guard let image = imageLoader.image else { return }
        let activityVC = UIActivityViewController(activityItems: [image, photo.title], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.present(activityVC, animated: true)
        }
    }
}

struct AnimateImageTransition: ViewModifier {
    func body(content: Content) -> some View {
        content
            .animation(.easeInOut(duration: 0.3), value: 1)
    }
}
