//
//  FlickrImageVIewModel.swift
//  SearchForFlickrImages
//
//  Created by Ke Liu on 2/6/25.
//

import Foundation
import Combine

class FlickrImageVIewModel: ObservableObject {
    @Published var searchText = ""
    @Published var photos: [FlickrImageModel] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.fetchPhotos(query: text)
            }
            .store(in: &cancellables)
    }
    
    func fetchPhotos(query: String) {
        guard !query.isEmpty else {
            photos = []
            return
        }
        
        isLoading = true
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(query)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: FlickrResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in self.isLoading = false }, receiveValue: { response in
                self.photos = response.items
            })
            .store(in: &cancellables)
    }
}
