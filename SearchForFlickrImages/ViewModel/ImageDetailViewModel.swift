//
//  ImageDetailViewModel.swift
//  SearchForFlickrImages
//
//  Created by Ke Liu on 2/6/25.
//

import Foundation

struct ImageDetailViewModel {
    let image: FlickrImageModel

    var title: String {
        image.title
    }
    
    var description: String {
        image.description.attributedHtmlString?.string ?? ""
    }
    
    var author: String {
        "Author: \(image.author)"
    }
    
    var publishedDate: String {
        "Published date: \(formatPublishedDate() ?? "")"
    }
    
    var dimension: String {
        "Image Width: \(image.description.extractImageDimensions()?.width ?? 0), Height: \(image.description.extractImageDimensions()?.height ?? 0)"
    }
    
    func formatPublishedDate() -> String? {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime]
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .short
        
        if let date = inputFormatter.date(from: image.published) {
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
}

// Add functionalities
extension String {
    
    // Display HTML string
    var attributedHtmlString: NSAttributedString? {
        try? NSAttributedString(
            data: Data(utf8),
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
    }
    
    // Display image size
    func extractImageDimensions() -> (width: Int, height: Int)? {
        let pattern = "width=\"(\\d+)\" height=\"(\\d+)\""
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            let widthRange = Range(match.range(at: 1), in: self)
            let heightRange = Range(match.range(at: 2), in: self)
            if let widthString = widthRange.map({ String(self[$0]) }),
               let heightString = heightRange.map({ String(self[$0]) }),
               let width = Int(widthString),
               let height = Int(heightString) {
                return (width, height)
            }
        }
        return nil
    }
}
