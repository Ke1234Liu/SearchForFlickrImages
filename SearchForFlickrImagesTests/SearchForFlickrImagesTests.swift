//
//  SearchForFlickrImagesTests.swift
//  SearchForFlickrImagesTests
//
//  Created by Ke Liu on 2/6/25.
//

import XCTest
@testable import SearchForFlickrImages

final class SearchForFlickrImagesTests: XCTestCase {

    var service: FlickrService!
    var urlSession: URLSession!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        urlSession = URLSession(configuration: configuration)
        service = FlickrService(session: urlSession)
    }
    
    override func tearDown() {
        service = nil
        urlSession = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testNetworkErrorStatusCode() async {
        // Mock 404 response
        let response = HTTPURLResponse(
            url: URL(string: "https://flickr.com")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )!
        
        URLProtocolMock.requestHandler = { request in
            (response, Data())
        }
        
        do {
            _ = try await service.fetchImages(for: "test")
            XCTFail("Expected networkErrorStatusCode to be thrown")
        } catch FlickrNetworkError.networkErrorStatusCode(let code) {
            XCTAssertEqual(code, 404, "Status code should be 404")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testDecodingError() async {
        // Invalid JSON data
        let invalidData = Data("Corrupted data".utf8)
        let response = HTTPURLResponse(
            url: URL(string: "https://flickr.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        URLProtocolMock.requestHandler = { request in
            (response, invalidData)
        }
        
        do {
            _ = try await service.fetchImages(for: "test")
            XCTFail("Expected decodingError to be thrown")
        } catch FlickrNetworkError.decodingError {
            // Test passed
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testURLConstruction() async {
        let expectation = XCTestExpectation(description: "Verify URL query parameters")
        let expectedTag = "testTag"
        
        URLProtocolMock.requestHandler = { request in
            guard let url = request.url,
                  let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                XCTFail("Invalid URL")
                return (HTTPURLResponse(), Data())
            }
            
            // Validate query parameters
            XCTAssertEqual(components.queryItems?.count, 3)
            XCTAssertTrue(components.queryItems!.contains(URLQueryItem(name: "format", value: "json")))
            XCTAssertTrue(components.queryItems!.contains(URLQueryItem(name: "nojsoncallback", value: "1")))
            XCTAssertTrue(components.queryItems!.contains(URLQueryItem(name: "tags", value: expectedTag)))
            
            expectation.fulfill()
            
            // Return empty valid response
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data("{\"items\":[]}".utf8))
        }
        
        do {
            _ = try await service.fetchImages(for: expectedTag)
            await fulfillment(of: [expectation], timeout: 1.0)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
