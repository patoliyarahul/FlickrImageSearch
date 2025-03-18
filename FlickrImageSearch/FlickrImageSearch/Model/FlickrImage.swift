//
//  FlickrImage.swift
//  FlickrImageSearch
//
//

import Foundation

// MARK: - PhotoFeed
struct PhotoFeed: Codable {
    let items: [Photo]
}

// MARK: - Photo
struct Photo: Codable, Identifiable {
    let id = UUID()
    let title: String
    let link: String
    let media: Media
    let description: String
    let published: Date
    let author: String

    enum CodingKeys: String, CodingKey {
        case title, link, media
        case published, author, description
    }
}

// MARK: - Media
struct Media: Codable {
    let m: String
}

// MARK: - Date Formatting
extension Photo {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? "No Title"
        self.link = try container.decodeIfPresent(String.self, forKey: .link) ?? ""
        self.media = try container.decode(Media.self, forKey: .media)
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? "No Description"
        self.author = try container.decodeIfPresent(String.self, forKey: .author) ?? "Unknown"
        
        let publishedString = try container.decodeIfPresent(String.self, forKey: .published) ?? ""
        self.published = Photo.dateFormatter.date(from: publishedString) ?? Date()
    }
}
