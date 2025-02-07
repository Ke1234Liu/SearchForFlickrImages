//
//  SearchView.swift
//  SearchForFlickrImages
//
//  Created by Ke Liu on 2/6/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = FlickrImageVIewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for images", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if viewModel.isLoading {
                    ProgressView()
                }
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 10) {
                        ForEach(viewModel.photos) { photo in
                            NavigationLink(destination: DetailView(photo: photo)) {
                                AsyncImage(url: URL(string: photo.media.m)) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(height: 100)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Flickr Search")
        }
    }
}

#Preview {
    SearchView()
}
