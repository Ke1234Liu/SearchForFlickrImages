//
//  DetailView.swift
//  SearchForFlickrImages
//
//  Created by Ke Liu on 2/6/25.
//

import SwiftUI
import Combine

struct DetailView: View {
    let image: FlickrImageModel
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: image.media.m)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(maxHeight: 300)
            
            Text(image.title).font(.headline).padding()
            Text(image.author).font(.subheadline).padding()
            Text(image.published).font(.caption).padding()
            Text(image.description).font(.body).padding()
        }
        .navigationTitle("Image Detail")
        .padding()
    }
}
