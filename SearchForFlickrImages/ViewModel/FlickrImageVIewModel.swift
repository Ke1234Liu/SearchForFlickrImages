//
//  FlickrImageViewModel.swift
//  SearchForFlickrImages
//
//  Created by Ke Liu on 2/6/25.
//

import Foundation
import Combine

@MainActor
class FlickrImageViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published var images: [FlickrImageModel] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    let flickrService: FlickrService
    
    init(flickrService: FlickrService = FlickrService()) {
        self.flickrService = flickrService
        
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.fetchImages(tags: text)
            }
            .store(in: &cancellables)
    }
    
    func fetchImages(tags: String) {
        guard !tags.isEmpty else {
            images = []
            return
        }

        isLoading = true

        Task {
            do {
                let images = try await flickrService.fetchImages(for: tags)
                self.isLoading = false
                self.images = images
            } catch {
                self.isLoading = false
            }
        }
    }
}
