//
//  SearchView.swift
//  SearchForFlickrImages
//
//  Created by Ke Liu on 2/6/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = FlickrImageViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for images", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if viewModel.isLoading {
                    progressView
                } else {
                    imagesCollectionView
                }
            }
            .navigationTitle("Search for Flickr images")
        }
    }
    
    var imagesCollectionView: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 10) {
                ForEach(viewModel.images) { image in
                    NavigationLink(destination: DetailView(viewModel: ImageDetailViewModel(image: image))) {
                        AsyncImage(url: URL(string: image.media.m)) { image in
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
    
    var progressView: some View {
        ProgressView("Loading...")
            .padding()
    }
}

#Preview {
    SearchView()
}
