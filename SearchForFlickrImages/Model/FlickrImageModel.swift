//
//  FlickrImageModel.swift
//  SearchForFlickrImages
//
//  Created by Ke Liu on 2/6/25.
//

import Foundation

struct FlickrImageModel: Codable, Identifiable {
    let id = UUID()
    let title: String
    let media: Media
    let author: String
    let published: String
    let description: String
    
    struct Media: Codable {
        let m: String
    }
}

struct FlickrResponse: Codable {
    let items: [FlickrImageModel]
}
