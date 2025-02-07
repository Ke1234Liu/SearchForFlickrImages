//
//  DetailView.swift
//  SearchForFlickrImages
//
//  Created by Ke Liu on 2/6/25.
//

import SwiftUI
import Combine

struct DetailView: View {
    let viewModel: ImageDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.title)
                    .font(.title)
                
                AsyncImage(url: URL(string: viewModel.image.media.m)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(maxHeight: 300)
                
                Text(viewModel.description)
                    .font(.body)
                
                Text(viewModel.author)
                    .font(.body)
                
                Text(viewModel.publishedDate)
                    .font(.body)
                
                Text(viewModel.dimension)
                    .font(.body)
            }
            .padding()
        }
    }
    
    
}
