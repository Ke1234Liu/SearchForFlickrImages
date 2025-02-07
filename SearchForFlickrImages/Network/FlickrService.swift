//
//  FlickrService.swift
//  SearchForFlickrImages
//
//  Created by Ke Liu on 2/6/25.
//

import Foundation

protocol FlickrServiceProtocol {
    func fetchImages(for tag: String) async throws -> [FlickrImageModel]
}

class FlickrService {
    private let path = "https://www.flickr.com/services/feeds/photos_public.gne"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    private func getCompleteURL(with tags: String) -> URL? {
        var components = URLComponents(string: path)
        let format = URLQueryItem(name: "format", value: "json")
        let callback = URLQueryItem(name: "nojsoncallback", value: "1")
        let tags = URLQueryItem(name: "tags", value: tags)
        
        components?.queryItems = [format, callback, tags]
        
        return components?.url
    }
}

extension FlickrService: FlickrServiceProtocol {

    func fetchImages(for tag: String) async throws -> [FlickrImageModel] {
        // bad url
        guard let url = getCompleteURL(with: tag) else {
            throw FlickrNetworkError.invalidURL
        }
        
        // network request
        let (data, response) = try await session.data(from: url)
 
        // bad response
        if let httpResponse = response as? HTTPURLResponse,
           !(200..<300).contains(httpResponse.statusCode) {
            throw FlickrNetworkError.networkErrorStatusCode(httpResponse.statusCode)
        }
        
        // decode
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(FlickrImageResponse.self, from: data)
            return response.items
        } catch {
            // bad decoding
            throw FlickrNetworkError.decodingError(error)
        }
    }
}
