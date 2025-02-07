//
//  FlickrNetworkError.swift
//  SearchForFlickrImages
//
//  Created by Ke Liu on 2/6/25.
//

import Foundation

enum FlickrNetworkError: Error {
    case invalidURL
    case networkErrorStatusCode(Int)
    case decodingError(Error)
}
