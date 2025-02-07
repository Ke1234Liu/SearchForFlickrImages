//
//  DetailView.swift
//  SearchForFlickrImages
//
//  Created by Ke Liu on 2/6/25.
//

import SwiftUI
//
//  ContentView.swift
//  SwiftUICombineSearchImages
//
//  Created by Ke Liu on 1/30/25.
//

import SwiftUI
import Combine

struct DetailView: View {
    let photo: FlickrImageModel
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: photo.media.m)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(maxHeight: 300)
            
            Text(photo.title).font(.headline).padding()
            Text(photo.author).font(.subheadline).padding()
            Text(photo.published).font(.caption).padding()
            Text(photo.description).font(.body).padding()
        }
        .navigationTitle("Photo Detail")
        .padding()
    }
}
